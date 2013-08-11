#include "pndmanager.h"
#include "pnddeclarativeimageprovider.h"
#include <QDebug>

QString const PNDManager::REPOSITORY_URL("http://repo.openpandora.org/client/masterlist?com=true&bzip=true");

PNDManager::PNDManager(QObject* parent) : QObject(parent),
  context(new QPndman::Context),
  repository(new QPndman::Repository(context, REPOSITORY_URL)),
  localRepository(new QPndman::LocalRepository(context)),
  packages(), packagesById(), devices(), commitableDevices(),
  downloadWorker(context), runningApplication(), applicationRunning(false)
{
  qDebug() << "PNDManager::PNDManager";

  connect(&runningApplication, SIGNAL(started()), this, SLOT(applicationStarted()));
  connect(&runningApplication, SIGNAL(finished(int)), this, SLOT(applicationFinished()));

  devices.append(QPndman::Device::detectDevices(context));
  foreach(QPndman::Device* device, devices)
  {
    qDebug() << " * Reading from" << device->getMount();
    bool canRead = false;
    canRead |= repository->loadFrom(device, false);
    canRead |= localRepository->loadFrom(device, false);
    if(canRead)
    {
      commitableDevices << device;
    }
  }

  connect(this, SIGNAL(usernameChanged()), this, SLOT(login()));
  connect(this, SIGNAL(keyChanged()), this, SLOT(login()));

  repository->update();
  localRepository->update();
  downloadWorker.start(QThread::LowPriority);
  PNDDeclarativeImageProvider::registerPNDManager(this);
}

PNDManager::~PNDManager()
{
  downloadWorker.stop();
  saveRepositories();
  delete context;
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

Package *PNDManager::getPackageById(const QString &id)
{
  qDebug() << "PNDManager::getPackageById " << id;
  return packagesById.value(id, 0);
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

int PNDManager::getVerbosity() const
{
  return context->getLoggingVerbosity();
}

void PNDManager::setVerbosity(int level)
{
  if(level != context->getLoggingVerbosity()) {
    context->setLoggingVerbosity(level);
    emit verbosityChanged(level);
  }
}

bool PNDManager::getApplicationRunning() const
{
  return applicationRunning;
}

QString PNDManager::getUsername() const
{
  return username;
}

QString PNDManager::getKey() const
{
  return key;
}

void PNDManager::setUsername(const QString newUsername)
{
  if(newUsername != username)
  {
    username = newUsername;
    emit usernameChanged();
  }
}

void PNDManager::setKey(const QString newKey)
{
  if(newKey != key)
  {
    key = newKey;
    emit keyChanged();
  }
}


void PNDManager::crawl()
{
  qDebug() << "Crawling";
  emit crawling();
  int found = context->crawlAllPndmanDevices();
  qDebug() << "Found" << found << "new installed packages";
  updatePackages();
  emit crawlDone();
}

void PNDManager::crawl(QString packageId)
{
  qDebug() << "Crawling " << packageId;
  emit crawling();
  context->crawlPndmanPackageById(packageId);
  updatePackages();
  emit crawlDone();
}

void PNDManager::sync()
{
  QPndman::SyncHandle* handle = repository->sync(false);
  emit syncing(handle);
  connect(handle, SIGNAL(done()), this, SLOT(syncFinished()));
  connect(handle, SIGNAL(done()), handle, SLOT(deleteLater()));
  connect(handle, SIGNAL(errorChanged(QString)), this, SIGNAL(error(QString)));
  connect(handle, SIGNAL(errorChanged(QString)), this, SIGNAL(syncError()));
}

void PNDManager::updatePackages()
{
  qDebug() << "PNDManager::updatePackages";
  QList<QPndman::Package*> installedPackages = localRepository->getPackages();
  qDebug() << installedPackages.size() << "installed packages";
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
    QPndman::Package* localPackage = installed.value(p->getId(), 0);
    QPndman::Package* remotePackage = remote.value(p->getId(), 0);
    if(localPackage || remotePackage)
    {
      p->setRemotePackage(remotePackage);
      p->setLocalPackage(localPackage);
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
      QPndman::Package* remotePackage = remote.value(p->getId(), 0);
      Package* package = new Package(this, p, remotePackage, this);
      packagesById.insert(package->getId(), package);
      packages << package;
    }
  }

  foreach(QPndman::Package* p, remotePackages)
  {
    if(!packagesById.contains(p->getId()))
    {
      Package* package = new Package(this, 0, p, this);
      packagesById.insert(package->getId(), package);
      packages << package;
    }
  }

  qDebug() << "Total" << packages.count() << "packages";
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

void PNDManager::execute(QString const& pndId)
{
  Package* pnd = packagesById.value(pndId, 0);
  if(pnd)
  {
    QStringList fullPath;
    fullPath << pnd->getMount() << QDir::separator() << pnd->getPath();
    QFile pndFile(fullPath.join(""));
    if(pndFile.exists())
    {
      runningApplication.start("pnd_run", QStringList(pndFile.fileName()), QIODevice::NotOpen);
    }
  }
}

void PNDManager::login()
{
  if(!username.isEmpty() && !key.isEmpty())
  {
    qDebug() << "setting credentials to" << username << key;
    repository->setCredentials(username, key);
  }
}

void PNDManager::applicationStarted()
{
  applicationRunning = true;
  emit applicationRunningChanged(true);
}

void PNDManager::applicationFinished()
{
  applicationRunning = false;
  emit applicationRunningChanged(false);
}

void PNDManager::syncFinished()
{
  repository->update();
  crawl();
  emit syncDone();
}
