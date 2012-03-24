#include "package.h"
#include "pndmanager.h"
#include "downloadworker.h"
#include <QDebug>

Package::Package(PNDManager* manager, QPndman::Package* p, bool installed, QObject* parent):
  QObject(parent), manager(manager), package(p), id(p->getId()),
  installed(installed), bytesDownloaded(installed ? 1 : 0), bytesToDownload(1),
  applicationList(), titleList(), descriptionList(), categoryList(), installedInstanceList(), overrideIcon(), overrideRating(0)
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
  if(installed || !overrideIcon.isEmpty())
  {
    return overrideIcon;
  }
  else
  {
    return !package ? "" : package->getIcon();
  }
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
QString Package::getMount() const
{
  return !package ? "" : package->getMount();
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
  if(overrideRating)
  {
    return overrideRating;
  }
  else
  {
    return !package ? 0 : package->getRating();
  }
}
QPndman::Author* Package::getAuthor() const
{
  return !package ? 0 : package->getAuthor();
}
QPndman::Version* Package::getVersion() const
{
  return !package ? 0 : package->getVersion();
}
QString Package::getTitle() const
{
  return !package ? "" : package->getTitle();
}

QString Package::getDescription() const
{
  return !package ? "" : package->getDescription();
}

QPndman::Package* Package::getUpgradeCandidate() const
{
  return !package ? 0 : package->getUpgradeCandidate();
}

QList<QPndman::Application*> Package::getApplications() const
{
  return !package ? QList<QPndman::Application*>() : package->getApplications();
}
QList<QPndman::TranslatedString*> Package::getTitles() const
{
  return !package ? QList<QPndman::TranslatedString*>() : package->getTitles();
}
QList<QPndman::TranslatedString*> Package::getDescriptions() const
{
  return !package ? QList<QPndman::TranslatedString*>() : package->getDescriptions();
}
QList<QPndman::Category*> Package::getCategories() const
{
  return !package ? QList<QPndman::Category*>() : package->getCategories();
}
QList<QPndman::PreviewPicture*> Package::getPreviewPictures() const
{
  return !package ? QList<QPndman::PreviewPicture*>() : package->getPreviewPictures();
}
QList<QPndman::Package*> Package::getInstallInstances() const
{
  return !package ? QList<QPndman::Package*>() : package->getInstallInstances();
}



QDeclarativeListProperty<QPndman::Application> Package::getApplicationsProperty()
{
  if(applicationList.isEmpty() && package)
    applicationList = package->getApplications();
  qDebug() << "Application count: " << applicationList.count();
  return QDeclarativeListProperty<QPndman::Application>(package.data(), applicationList);
}
QDeclarativeListProperty<QPndman::TranslatedString> Package::getTitlesProperty()
{
  if(titleList.isEmpty() && package)
    titleList = package->getTitles();
  return QDeclarativeListProperty<QPndman::TranslatedString>(package.data(), titleList);
}
QDeclarativeListProperty<QPndman::TranslatedString> Package::getDescriptionsProperty()
{
  if(descriptionList.isEmpty() && package)
    descriptionList = package->getDescriptions();
  return QDeclarativeListProperty<QPndman::TranslatedString>(package.data(), descriptionList);
}
QDeclarativeListProperty<QPndman::Category> Package::getCategoriesProperty()
{
  if(categoryList.isEmpty() && package)
    categoryList = package->getCategories();
  return QDeclarativeListProperty<QPndman::Category>(package.data(), categoryList);
}
QDeclarativeListProperty<QPndman::PreviewPicture> Package::getPreviewPicturesProperty()
{
  if(previewPictureList.isEmpty() && package)
    previewPictureList = package->getPreviewPictures();
  return QDeclarativeListProperty<QPndman::PreviewPicture>(package.data(), previewPictureList);
}
QDeclarativeListProperty<QPndman::Package> Package::getInstallInstancesProperty()
{
  if(installedInstanceList.isEmpty() && package)
    installedInstanceList = package->getInstallInstances();
  return QDeclarativeListProperty<QPndman::Package>(package.data(), installedInstanceList);
}

int Package::applicationCount() const
{
  return package ? package->getApplications().count() : 0;
}
int Package::titleCount() const
{
  return package ? package->getTitles().count() : 0;
}
int Package::descriptionCount() const
{
  return package ? package->getDescriptions().count() : 0;
}
int Package::categoryCount() const
{
  return package ? package->getCategories().count() : 0;
}
int Package::previewPictureCount() const
{
  return package ? package->getPreviewPictures().count() : 0;
}
int Package::installInstanceCount() const
{
  return package ? package->getInstallInstances().count() : 0;
}

QPndman::Application* Package::getApplication(int i) const
{
  return package ? package->getApplications().at(i) : 0;
}
QPndman::TranslatedString* Package::getTitle(int i) const
{
  return package ? package->getTitles().at(i) : 0;
}
QPndman::TranslatedString* Package::getDescription(int i) const
{
  return package ? package->getDescriptions().at(i) : 0;
}
QPndman::Category* Package::getCategory(int i) const
{
  return package ? package->getCategories().at(i) : 0;
}
QPndman::PreviewPicture* Package::getPreviewPicture(int i) const
{
  return package ? package->getPreviewPictures().at(i) : 0;
}
QPndman::Package* Package::getInstallInstance(int i) const
{
  return package ? package->getInstallInstances().at(i) : 0;
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
    if(device->getMount() == getMount())
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
  applicationList.clear();
  titleList.clear();
  descriptionList.clear();
  categoryList.clear();
  installedInstanceList.clear();
  previewPictureList.clear();

  QPndman::Package* old = package;
  package = other;

  if(old && ((old->getUpgradeCandidate() != 0) != (package->getUpgradeCandidate() != 0)))
    emit hasUpgradeChanged();
  emit installedChanged(other->getInstallInstances().count() > 0);
}

void Package::setOverrideIcon(QString newIcon)
{
  overrideIcon = newIcon;
}

void Package::setOverrideRating(int newRating)
{
  overrideRating = newRating;
}

void Package::setPreviewPictureList(QList<QPndman::PreviewPicture *> newPreviewPictures)
{
  previewPictureList = newPreviewPictures;
}
