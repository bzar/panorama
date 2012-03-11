#include "pndmanager.h"
#include "syncworker.h"
#include "downloadworker.h"

#include <QDebug>

QString const PNDManager::REPOSITORY_URL("http://repo.openpandora.org/includes/get_data.php");
//QString const PNDManager::REPOSITORY_URL("http://ewmedia/repo.json");

PNDManager::PNDManager(QObject* parent) : QObject(parent), 
  context(new QPndman::Context(this)),
  repository(new QPndman::Repository(context, REPOSITORY_URL)),
  localRepository(new QPndman::LocalRepository(context)),
  tmpDevice(new QPndman::Device(context, "/tmp")),
  packages(), packagesById(), devices()
{
  repository->loadFrom(tmpDevice);
  localRepository->loadFrom(tmpDevice);
  devices << tmpDevice;
  devices.append(QPndman::Device::detectDevices(context));
}

PNDManager::~PNDManager()
{
  tmpDevice->saveRepositories();
}

QList< QObject* > PNDManager::getDevices()
{
  QList< QObject* > result;
  foreach(QPndman::Device* device, devices)
  {
    result << device;
  }
  return result;
}

QList< Package* > PNDManager::getPackages()
{
  return packages;
}

PNDFilter* PNDManager::getPackagesQObject()
{
  return new PNDFilter(packages);
}


void PNDManager::crawl()
{
  qDebug() << "PNDManager::crawl";
  emit crawling();
  foreach(QPndman::Device* device, devices)
  {
    qDebug() << "Crawling" << device->getDevice();
    device->crawl();
  }
  qDebug() << "Updating remote repository";
  repository->update();
  qDebug() << "Updating local repository";
  localRepository->update();
  qDebug() << "Updating package list";
  updatePackages();
  emit crawlDone();
}

void PNDManager::sync()
{
  qDebug() << "PNDManager::sync";
  QPndman::SyncHandle* handle = repository->sync();
  emit syncing(handle);
  SyncWorker* worker = new SyncWorker(handle);
  handle->setParent(worker);
  connect(worker, SIGNAL(ready(QPndman::SyncHandle*)), repository, SLOT(update()));
  connect(worker, SIGNAL(ready(QPndman::SyncHandle*)), this, SLOT(updatePackages()));
  connect(worker, SIGNAL(ready(QPndman::SyncHandle*)), this, SIGNAL(syncDone()));
  worker->start();
}

void PNDManager::updatePackages()
{
  qDebug() << "PNDManager::updatePackages";
  QList<QPndman::Package> installedPackages = localRepository->getPackages();
  QList<QPndman::Package> remotePackages = repository->getPackages();

  QMap<QString, QPndman::Package> installed;
  foreach(QPndman::Package p, installedPackages)
  {
    installed.insert(p.getId(), p);
  }

  QMap<QString, QPndman::Package> remote;
  foreach(QPndman::Package p, remotePackages)
  {
    remote.insert(p.getId(), p);
  }

  QMutableListIterator<Package*> i(packages);
  packagesById.clear();
  while(i.hasNext())
  {
    Package* p = i.next();
    bool isInInstalled = installed.contains(p->getId());
    if(isInInstalled || remote.contains(p->getId()))
    {
      p->setInstalled(isInInstalled);
      QPndman::Package package = isInInstalled ? installed.value(p->getId()) : remote.value(p->getId());
      p->updateFrom(package);
      packagesById.insert(p->getId(), p);
    }
    else
    {
      i.remove();
      delete p;
    }
  }

  foreach(QPndman::Package p, installedPackages)
  {
    if(!packagesById.contains(p.getId()))
    {
      Package* package = new Package(this, p, true, this);
      packagesById.insert(package->getId(), package);
      packages << package;
    }
  }

  foreach(QPndman::Package p, remotePackages)
  {
    if(!packagesById.contains(p.getId()))
    {
      Package* package = new Package(this, p, false, this);
      packagesById.insert(package->getId(), package);
      packages << package;
    }
  }

  qDebug() << "Found" << packages.count() << "packages";
  emit packagesChanged();
}

void PNDManager::install(Package* package, QPndman::Device* device, QPndman::Enum::InstallLocation location)
{
  qDebug() << "PNDManager::install";
  QPndman::InstallHandle* handle = device->install(*package, location);
  if(!handle)
  {
    emit(error(QString("Error installing %1").arg(package->getTitle())));
    return;
  }
  DownloadWorker* worker = new DownloadWorker(handle);
  handle->setParent(worker);
  connect(handle, SIGNAL(bytesDownloadedChanged(qint64)), package, SLOT(setBytesDownloaded(qint64)));
  connect(handle, SIGNAL(bytesToDownloadChanged(qint64)), package, SLOT(setBytesToDownload(qint64)));
  connect(handle, SIGNAL(done()), package, SLOT(setInstalled()));
  connect(handle, SIGNAL(done()), this, SLOT(crawl()));
  connect(worker, SIGNAL(started(QPndman::Handle*)), this, SIGNAL(packagesChanged()));
  worker->start();
  emit installing(package);
}

void PNDManager::remove(Package* package)
{
  qDebug() << "PNDManager::remove";
  foreach(QPndman::Device* device, devices)
  {
    if(device->getDevice() == package->getDevice())
    {
      if(device->remove(*package))
      {
        package->setBytesDownloaded(0);
        package->setInstalled(false);
        crawl();
      }
      else
      {
        emit error("Error removing pnd");
      }
    }
  }
}

void PNDManager::upgrade(Package* package)
{
  qDebug() << "PNDManager::upgrade";
  QPndman::UpgradeHandle* handle = package->upgradePackage(false);
  if(!handle)
  {
    emit(error(QString("Error upgrading %1").arg(package->getTitle())));
    return;
  }
  DownloadWorker* worker = new DownloadWorker(handle);
  handle->setParent(worker);
  connect(handle, SIGNAL(bytesDownloadedChanged(qint64)), package, SLOT(setBytesDownloaded(qint64)));
  connect(handle, SIGNAL(bytesToDownloadChanged(qint64)), package, SLOT(setBytesToDownload(qint64)));
  connect(handle, SIGNAL(done()), package, SLOT(setInstalled()));
  connect(handle, SIGNAL(done()), this, SLOT(crawl()));
  connect(worker, SIGNAL(started(QPndman::Handle*)), this, SIGNAL(packagesChanged()));
  worker->start();
  emit upgrading(package);
}
