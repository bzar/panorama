#include "pndmanager.h"
#include "syncworker.h"

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

QDeclarativeListProperty<QPndman::Device> PNDManager::getDevices()
{
  return QDeclarativeListProperty<QPndman::Device>(this, devices);
}

int PNDManager::deviceCount() const
{
  return devices.count();
}

QPndman::Device *PNDManager::getDevice(int i) const
{
  return devices.at(i);
}

PNDFilter* PNDManager::getPackages()
{
  return new PNDFilter(packages);
}

QPndman::Context* PNDManager::getContext() const
{
  return context;
}


void PNDManager::crawl()
{
  qDebug() << "PNDManager::crawl";
  emit crawling();
  foreach(QPndman::Device* device, devices)
  {
    qDebug() << "Crawling" << device->getMount();
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
  connect(worker, SIGNAL(ready(QPndman::SyncHandle*)), this, SLOT(crawl()));
  connect(worker, SIGNAL(ready(QPndman::SyncHandle*)), this, SIGNAL(syncDone()));
  worker->start();
}

void PNDManager::updatePackages()
{
  qDebug() << "PNDManager::updatePackages";
  QList<QPndman::Package*> installedPackages = localRepository->getPackages();
  QList<QPndman::Package*> remotePackages = repository->getPackages();

  QMap<QString, QPndman::Package*> installed;
  foreach(QPndman::Package* p, installedPackages)
  {
    installed.insert(p->getId(), p);
  }

  QMap<QString, QPndman::Package*> remote;
  foreach(QPndman::Package* p, remotePackages)
  {
    remote.insert(p->getId(), p);
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
      QPndman::Package* package = isInInstalled ? installed.value(p->getId()) : remote.value(p->getId());
      p->updateFrom(package);
      packagesById.insert(p->getId(), p);
    }
    else
    {
      i.remove();
      p->deleteLater();
    }
  }

  foreach(QPndman::Package* p, installedPackages)
  {
    if(!packagesById.contains(p->getId()))
    {
      Package* package = new Package(this, p, true, this);
      packagesById.insert(package->getId(), package);
      packages << package;
    }
  }

  foreach(QPndman::Package* p, remotePackages)
  {
    if(!packagesById.contains(p->getId()))
    {
      Package* package = new Package(this, p, false, this);
      packagesById.insert(package->getId(), package);
      packages << package;
    }
  }

  qDebug() << "Found" << packages.count() << "packages";
  emit packagesChanged();
}

