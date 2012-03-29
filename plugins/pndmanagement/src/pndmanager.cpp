#include "pndmanager.h"
#include "syncworker.h"

#include <QDebug>

QString const PNDManager::REPOSITORY_URL("http://repo.openpandora.org/includes/get_data.php");

PNDManager::PNDManager(QObject* parent) : QObject(parent), 
  context(new QPndman::Context(this)),
  repository(new QPndman::Repository(context, REPOSITORY_URL)),
  localRepository(new QPndman::LocalRepository(context)),
  packages(), packagesById(), devices(), commitableDevices()
{
  devices.append(QPndman::Device::detectDevices(context));
  foreach(QPndman::Device* device, devices)
  {
    bool canRead = false;
    canRead |= repository->loadFrom(device);
    canRead |= localRepository->loadFrom(device);
    if(canRead)
    {
      commitableDevices << device;
    }
  }
}

PNDManager::~PNDManager()
{
  saveRepositories();
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

PNDFilter* PNDManager::searchPackages(const QString &search)
{
  QList<Package*> result;
  foreach(Package* package, packages)
  {
    bool matches = false;

    foreach(QPndman::TranslatedString const* title, package->getTitles())
    {
      if(title->getContent().contains(search, Qt::CaseInsensitive))
      {
        matches = true;
        break;
      }
    }

    if(!matches)
    {
      foreach(QPndman::TranslatedString const* description, package->getDescriptions())
      {
        if(description->getContent().contains(search, Qt::CaseInsensitive))
        {
          matches = true;
          break;
        }
      }
    }

    if(!matches)
    {
      foreach(QPndman::Category const* category, package->getCategories())
      {
        if(category->getMain().contains(search, Qt::CaseInsensitive)
           || category->getSub().contains(search, Qt::CaseInsensitive))
        {
          matches = true;
          break;
        }
      }
    }

    if(!matches && package->getAuthor()->getName().contains(search, Qt::CaseInsensitive))
    {
      matches = true;
    }

    if(matches)
    {
      result << package;
    }
  }

  return new PNDFilter(result);
}

QPndman::Context* PNDManager::getContext() const
{
  return context;
}

void PNDManager::addCommitableDevice(QPndman::Device *device)
{
  if(!commitableDevices.contains(device))
  {
    commitableDevices << device;
  }
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
      QPndman::Package* package = isInInstalled ? installed.value(p->getId(), 0) : remote.value(p->getId(), 0);

      if(package)
      {
        p->updateFrom(package);
      }

      // TODO: Temporary system to fetch icons from repo, replace with a QDeclarativeImageProvider system at some point
      if(isInInstalled)
      {
        QPndman::Package* remotePackage = remote.value(p->getId(), 0);
        if(remotePackage)
        {
          p->setOverrideIcon(remotePackage->getIcon());
          p->setPreviewPictureList(remotePackage->getPreviewPictures());
          p->setOverrideRating(remotePackage->getRating());
        }
      }

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

      QPndman::Package* remotePackage = remote.value(p->getId(), 0);
      if(remotePackage)
      {
        package->setOverrideIcon(remotePackage->getIcon());
        package->setPreviewPictureList(remotePackage->getPreviewPictures());
        package->setOverrideRating(remotePackage->getRating());
      }

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
  saveRepositories();
  emit packagesChanged();
}

void PNDManager::saveRepositories()
{
  if(commitableDevices.empty())
  {
    QSet<QString> mounts;
    foreach(Package* package, packages)
    {
      if(!package->getInstalled())
        continue;

      QString const mount = package->getMount();
      if(!mounts.contains(mount))
      {
        mounts.insert(mount);

        foreach(QPndman::Device* device, devices)
        {
          if(device->getMount() == mount)
          {
            commitableDevices.append(device);
            break;
          }
        }

        // If seen all devices, break
        if(mounts.count() == devices.count())
          break;
      }
    }
  }
  foreach(QPndman::Device* device, commitableDevices)
  {
    device->saveRepositories();
  }
}
