#include "package.h"
#include "pndmanager.h"
#include "downloadworker.h"
#include <QDebug>

Package::Package(PNDManager* manager, QPndman::Package* p, bool installed, QObject* parent):
  QObject(parent), manager(manager), package(p), id(p->getId()),
  installed(installed), bytesDownloaded(installed ? 1 : 0), bytesToDownload(1)
{
}

QString Package::getId() const
{
  return id;
}
QString Package::getPath() const
{
  return !package ? "" : package->getPath();
}
QString Package::getIcon() const
{
  return !package ? "" : package->getIcon();
}
QString Package::getInfo() const
{
  return !package ? "" : package->getInfo();
}
QString Package::getMd5() const
{
  return !package ? "" : package->getMd5();
}
QString Package::getUrl() const
{
  return !package ? "" : package->getUrl();
}
QString Package::getVendor() const
{
  return !package ? "" : package->getVendor();
}
QString Package::getDevice() const
{
  return !package ? "" : package->getDevice();
}
qint64 Package::getSize() const
{
  return !package ? 0 : package->getSize();
}
QDateTime Package::getModified() const
{
  return !package ? QDateTime() : package->getModified();
}
int Package::getRating() const
{
  return !package ? 0 : package->getRating();
}
QPndman::Author* Package::getAuthor() const
{
  return !package ? 0 : package->getAuthor();
}
QPndman::Version* Package::getVersion() const
{
  return !package ? 0 : package->getVersion();
}
QList<QPndman::Application*> Package::getApplications() const
{
  return !package ? QList<QPndman::Application*>() : package->getApplications();
}
QList<QPndman::TranslatedString*> Package::getTitles() const
{
  return !package ? QList<QPndman::TranslatedString*>() : package->getTitles();
}

QString Package::getTitle() const
{
  return !package ? "" : package->getTitle();
}

QList<QPndman::TranslatedString*> Package::getDescriptions() const
{
  return !package ? QList<QPndman::TranslatedString*>() : package->getDescriptions();
}
QString Package::getDescription() const
{
  return !package ? "" : package->getDescription();
}

QList<QPndman::Category*> Package::getCategories() const
{
  return !package ? QList<QPndman::Category*>() : package->getCategories();
}
QList<QPndman::Package*> Package::getInstallInstances() const
{
  return !package ? QList<QPndman::Package*>() : package->getInstallInstances();
}

QPndman::Package* Package::getUpgradeCandidate() const
{
  return !package ? 0 : package->getUpgradeCandidate();
}

bool Package::getInstalled() const
{
  return installed;
}

qint64 Package::getBytesDownloaded() const
{
  return bytesDownloaded;
}

qint64 Package::getBytesToDownload() const
{
  return bytesToDownload;
}

bool Package::getHasUpgrade() const
{
  return getUpgradeCandidate() != 0;
}

bool Package::getIsDownloading() const
{
  return bytesDownloaded > 0 && bytesDownloaded != bytesToDownload;
}

void Package::setInstalled()
{
  setBytesDownloaded(bytesToDownload);
  setInstalled(true);
}

void Package::setInstalled(bool value)
{
  if(installed != value)
  {
    installed = value;
    emit installedChanged(installed);
  }
}

void Package::setBytesDownloaded(qint64 value)
{
  if(bytesDownloaded != value)
  {
    bytesDownloaded = value;
    emit bytesDownloadedChanged(bytesDownloaded);
  }
}

void Package::setBytesToDownload(qint64 value)
{
  if(bytesToDownload != value)
  {
    bytesToDownload = value;
    emit bytesToDownloadChanged(bytesDownloaded);
  }
}

QString Package::getPNDIcon() const
{
  if(installed)
  {
    return QString("image://pnd/%1::%2").arg(getPath()).arg(getIcon());
  }
  else
  {
    return QString("image://pnd/%1").arg(getIcon());
  }
}

void Package::install(QPndman::Device* device, QString location)
{
  QPndman::Enum::InstallLocation installLocation = QPndman::Enum::DesktopAndMenu;
  if(location == "Desktop") {
    installLocation = QPndman::Enum::Desktop;
  } else if(location == "Menu") {
    installLocation = QPndman::Enum::Menu;
  }

  QPndman::InstallHandle* handle = device->install(package, installLocation);
  if(!handle)
  {
    return;
  }
  DownloadWorker* worker = new DownloadWorker(handle);
  handle->setParent(worker);
  connect(worker, SIGNAL(started(QPndman::Handle*)), manager, SIGNAL(packagesChanged()));
  connect(handle, SIGNAL(bytesDownloadedChanged(qint64)), this, SLOT(setBytesDownloaded(qint64)));
  connect(handle, SIGNAL(bytesToDownloadChanged(qint64)), this, SLOT(setBytesToDownload(qint64)));
  connect(handle, SIGNAL(done()), this, SLOT(setInstalled()));
  connect(handle, SIGNAL(done()), manager, SLOT(crawl()));
  worker->start();
}

void Package::remove()
{
  if(!package)
    return;

  for(int i = 0; i < manager->deviceCount(); ++i)
  {
    QPndman::Device* device = manager->getDevice(i);
    if(device->getDevice() == getDevice())
    {
      if(device->remove(package))
      {
        setBytesDownloaded(0);
        setInstalled(false);
        manager->crawl();
      }
    }
  }

}

void Package::upgrade()
{
  if(!package)
    return;

  QPndman::UpgradeHandle* handle = package->upgrade(false);
  if(!handle)
  {
    return;
  }
  DownloadWorker* worker = new DownloadWorker(handle);
  handle->setParent(worker);
  connect(worker, SIGNAL(started(QPndman::Handle*)), manager, SIGNAL(packagesChanged()));
  connect(handle, SIGNAL(bytesDownloadedChanged(qint64)), this, SLOT(setBytesDownloaded(qint64)));
  connect(handle, SIGNAL(bytesToDownloadChanged(qint64)), this, SLOT(setBytesToDownload(qint64)));
  connect(handle, SIGNAL(done()), this, SLOT(setInstalled()));
  connect(handle, SIGNAL(done()), manager, SLOT(crawl()));
  worker->start();
}

void Package::updateFrom(QPndman::Package* other)
{
  QPndman::Package* old = package;
  package = other;

  if(old && ((old->getUpgradeCandidate() != 0) != (package->getUpgradeCandidate() != 0)))
    emit hasUpgradeChanged();
}
