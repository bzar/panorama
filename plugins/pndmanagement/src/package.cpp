#include "package.h"
#include "pndmanager.h"

Package::Package(PNDManager* manager, QPndman::Package* localPackage, QPndman::Package* remotePackage, QObject* parent):
  QObject(parent), manager(manager), localPackage(localPackage), remotePackage(remotePackage), operationHandle(0),
  id(localPackage ? localPackage->getId() : remotePackage ? remotePackage->getId() : ""),
  bytesDownloaded(localPackage ? 1 : 0), bytesToDownload(1),
  applicationList(), titleList(), descriptionList(), categoryList()
{
  connect(this, SIGNAL(downloadStarted()), this, SIGNAL(isDownloadingChanged()));
  connect(this, SIGNAL(downloadCancelled()), this, SIGNAL(isDownloadingChanged()));
  connect(this, SIGNAL(installedChanged(bool)), this, SIGNAL(isDownloadingChanged()));
  connect(this, SIGNAL(downloadStarted()), this, SIGNAL(isQueuedChanged()));
  connect(this, SIGNAL(downloadEnqueued()), this, SIGNAL(isQueuedChanged()));
  connect(this, SIGNAL(downloadCancelled()), this, SIGNAL(isQueuedChanged()));

  if(remotePackage)
  {
    connect(remotePackage, SIGNAL(commentsChanged()), this, SLOT(handleCommentUpdate()));
    connect(remotePackage, SIGNAL(reloadCommentsDone()), this, SIGNAL(reloadCommentsDone()));
    connect(remotePackage, SIGNAL(addCommentDone()), this, SIGNAL(addCommentDone()));
    connect(remotePackage, SIGNAL(addCommentFail()), this, SIGNAL(addCommentFail()));
    connect(remotePackage, SIGNAL(deleteCommentDone()), this, SIGNAL(deleteCommentDone()));
    connect(remotePackage, SIGNAL(deleteCommentFail()), this, SIGNAL(deleteCommentFail()));
    connect(remotePackage, SIGNAL(rateDone()), this, SIGNAL(rateDone()));
    connect(remotePackage, SIGNAL(rateFail()), this, SIGNAL(rateFail()));
    connect(remotePackage, SIGNAL(ratingChanged()), this, SIGNAL(ratingChanged()));
    connect(remotePackage, SIGNAL(ownRatingChanged()), this, SIGNAL(ownRatingChanged()));
  }
}

QString Package::getId() const
{
  return id;
}
QString Package::getPath() const
{
  return !localPackage ? "" : localPackage->getPath();
}
QString Package::getIcon() const
{
  return !remotePackage ? "" : remotePackage->getIcon();
}
QString Package::getInfo() const
{
  return !remotePackage ? "" : remotePackage->getInfo().replace("\r", "");
}
QString Package::getMd5() const
{
  return lPackage() ? lPackage()->getMd5() : "";
}
QString Package::getUrl() const
{
  return !remotePackage ? "" : remotePackage->getUrl();
}
QString Package::getVendor() const
{
  return !remotePackage ? "" : remotePackage->getVendor();
}
QString Package::getMount() const
{
  return !localPackage ? "" : localPackage->getMount();
}
qint64 Package::getSize() const
{
  return lPackage() ? lPackage()->getSize() : 0;
}
QDateTime Package::getModified() const
{
  return rPackage() ? rPackage()->getModified() : QDateTime();
}
int Package::getRating() const
{
  return !remotePackage ? 0 : remotePackage->getRating();
}

int Package::getOwnRating() const
{
  return !remotePackage ? 0 : remotePackage->getOwnRating();
}

QPndman::Author* Package::getAuthor() const
{
  return rPackage() ? rPackage()->getAuthor() : 0;
}
QPndman::Version* Package::getLocalVersion() const
{
  return localPackage ? localPackage->getVersion() : 0;
}
QPndman::Version* Package::getRemoteVersion() const
{
  return remotePackage ? remotePackage->getVersion() : 0;
}
QString Package::getTitle() const
{
  return lPackage() ? lPackage()->getTitle() : 0;
}

QString Package::getDescription() const
{
  if(!rPackage())
    return "";

  QStringList lines;
  foreach(QString line, rPackage()->getDescription().split("\n"))
  {
    lines.append(line.trimmed());
  }

  return lines.join("\n");
}

QPndman::Package* Package::getUpgradeCandidate() const
{
  if(localPackage
     && localPackage->getUpgradeCandidate())
    return localPackage->getUpgradeCandidate();

  return 0;
}

QList<QPndman::Application*> Package::getApplications() const
{
  return rPackage() ? rPackage()->getApplications() : QList<QPndman::Application*>();
}
QList<QPndman::TranslatedString*> Package::getTitles() const
{
  return rPackage() ? rPackage()->getTitles() : QList<QPndman::TranslatedString*>();
}
QList<QPndman::TranslatedString*> Package::getDescriptions() const
{
  return rPackage() ? rPackage()->getDescriptions() : QList<QPndman::TranslatedString*>();
}
QList<QPndman::Category*> Package::getCategories() const
{
  return rPackage() ? rPackage()->getCategories() : QList<QPndman::Category*>();

}
QList<QPndman::PreviewPicture*> Package::getPreviewPictures() const
{
  return rPackage() ? rPackage()->getPreviewPictures() : QList<QPndman::PreviewPicture*>();
}

QList<QPndman::Comment *> Package::getComments() const
{
  return commentList;
}

QDeclarativeListProperty<QPndman::Application> Package::getApplicationsProperty()
{
  if(applicationList.isEmpty())
    applicationList = getApplications();
  return QDeclarativeListProperty<QPndman::Application>(rPackage(), applicationList);
}
QDeclarativeListProperty<QPndman::TranslatedString> Package::getTitlesProperty()
{
  if(titleList.isEmpty())
    titleList = getTitles();
  return QDeclarativeListProperty<QPndman::TranslatedString>(rPackage(), titleList);
}
QDeclarativeListProperty<QPndman::TranslatedString> Package::getDescriptionsProperty()
{
  if(descriptionList.isEmpty())
    descriptionList = getDescriptions();
  return QDeclarativeListProperty<QPndman::TranslatedString>(rPackage(), descriptionList);
}
QDeclarativeListProperty<QPndman::Category> Package::getCategoriesProperty()
{
  if(categoryList.isEmpty())
    categoryList = getCategories();
  return QDeclarativeListProperty<QPndman::Category>(rPackage(), categoryList);
}
QDeclarativeListProperty<QPndman::PreviewPicture> Package::getPreviewPicturesProperty()
{
  if(previewPictureList.isEmpty())
    previewPictureList = getPreviewPictures();
  return QDeclarativeListProperty<QPndman::PreviewPicture>(rPackage(), previewPictureList);
}

QDeclarativeListProperty<QPndman::Comment> Package::getCommentsProperty()
{
  return QDeclarativeListProperty<QPndman::Comment>(rPackage(), commentList);
}

int Package::applicationCount() const
{
  return getApplications().count();
}
int Package::titleCount() const
{
  return getTitles().count();
}
int Package::descriptionCount() const
{
  return getDescriptions().count();
}
int Package::categoryCount() const
{
  return getCategories().count();
}
int Package::previewPictureCount() const
{
  return getPreviewPictures().count();
}

QPndman::Application* Package::getApplication(int i) const
{
  return getApplications().at(i);
}
QPndman::TranslatedString* Package::getTitle(int i) const
{
  return getTitles().at(i);
}
QPndman::TranslatedString* Package::getDescription(int i) const
{
  return getDescriptions().at(i);
}
QPndman::Category* Package::getCategory(int i) const
{
  return getCategories().at(i);
}
QPndman::PreviewPicture* Package::getPreviewPicture(int i) const
{
  return getPreviewPictures().at(i);
}



bool Package::getInstalled() const
{
  return localPackage != 0;
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
  return operationHandle != 0
      && operationHandle->getExecuted();
}

bool Package::getIsQueued() const
{
  return operationHandle != 0
      && !operationHandle->getExecuted();
}

void Package::setInstalled()
{
  setBytesDownloaded(bytesToDownload);
  operationHandle = 0;
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
  if(!remotePackage)
    return;

  QPndman::Enum::InstallLocation installLocation = QPndman::Enum::DesktopAndMenu;
  if(location == "Desktop") {
    installLocation = QPndman::Enum::Desktop;
  } else if(location == "Menu") {
    installLocation = QPndman::Enum::Menu;
  }

  QPndman::InstallHandle* handle = new QPndman::InstallHandle(manager->getContext(), remotePackage, device, installLocation, false, this);

  connect(handle, SIGNAL(downloadStarted()), this, SIGNAL(downloadStarted()));
  connect(handle, SIGNAL(downloadStarted()), manager, SIGNAL(downloadStarted()));
  connect(handle, SIGNAL(bytesDownloadedChanged(qint64)), this, SLOT(setBytesDownloaded(qint64)));
  connect(handle, SIGNAL(bytesToDownloadChanged(qint64)), this, SLOT(setBytesToDownload(qint64)));

  connect(handle, SIGNAL(done()), this, SLOT(setInstalled()));
  connect(handle, SIGNAL(done()), this, SLOT(crawl()));
  connect(handle, SIGNAL(done()), handle, SLOT(deleteLater()));

  connect(handle, SIGNAL(cancelled()), this, SLOT(handleDownloadCancelled()));
  connect(handle, SIGNAL(cancelled()), handle, SLOT(deleteLater()));

  connect(handle, SIGNAL(error(QString)), this, SIGNAL(downloadError()));
  connect(handle, SIGNAL(error(QString)), manager, SIGNAL(downloadError()));
  connect(handle, SIGNAL(error(QString)), this, SLOT(handleDownloadCancelled()));
  connect(handle, SIGNAL(error(QString)), handle, SLOT(deleteLater()));

  operationHandle = handle;

  if(manager->enqueueHandle(handle))
  {
    emit downloadEnqueued();
  }

  manager->addCommitableDevice(device);
}

void Package::crawl()
{
  manager->crawl(id);
}

void Package::remove()
{
  if(!localPackage)
    return;

  for(int i = 0; i < manager->deviceCount(); ++i)
  {
    QPndman::Device* device = manager->getDevice(i);
    if(device->getMount() == getMount())
    {
      if(device->remove(localPackage))
      {
        setBytesDownloaded(0);
        setLocalPackage(0);
        manager->crawl();
      }
    }
  }

}

void Package::upgrade()
{
  if(!localPackage)
    return;

  QPndman::UpgradeHandle* handle = new QPndman::UpgradeHandle(manager->getContext(), localPackage->getUpgradeCandidate(), false, this);

  connect(handle, SIGNAL(downloadStarted()), this, SIGNAL(downloadStarted()));
  connect(handle, SIGNAL(downloadStarted()), manager, SIGNAL(downloadStarted()));
  connect(handle, SIGNAL(bytesDownloadedChanged(qint64)), this, SLOT(setBytesDownloaded(qint64)));
  connect(handle, SIGNAL(bytesToDownloadChanged(qint64)), this, SLOT(setBytesToDownload(qint64)));

  connect(handle, SIGNAL(done()), this, SLOT(setInstalled()));
  connect(handle, SIGNAL(done()), manager, SLOT(crawl()));
  connect(handle, SIGNAL(done()), handle, SLOT(deleteLater()));

  connect(handle, SIGNAL(cancelled()), this, SLOT(handleDownloadCancelled()));
  connect(handle, SIGNAL(cancelled()), handle, SLOT(deleteLater()));

  connect(handle, SIGNAL(error(QString)), this, SIGNAL(downloadError()));
  connect(handle, SIGNAL(error(QString)), manager, SIGNAL(downloadError()));
  connect(handle, SIGNAL(error(QString)), this, SLOT(handleDownloadCancelled()));
  connect(handle, SIGNAL(error(QString)), handle, SLOT(deleteLater()));

  operationHandle = handle;

  if(manager->enqueueHandle(handle))
  {
    emit downloadEnqueued();
  }
}

void Package::cancelDownload()
{
  if(operationHandle) {
    operationHandle->cancel();
  }
}

void Package::handleDownloadCancelled()
{
  operationHandle = 0;
  setBytesDownloaded(0);
  emit downloadCancelled();
}

void Package::handleCommentUpdate()
{
  if(remotePackage) {
    commentList = remotePackage->getComments();
    emit commentsChanged();
  }
}

void Package::reloadComments()
{
  if(remotePackage)
    remotePackage->reloadComments();
}

void Package::reloadOwnRating()
{
  if(remotePackage)
    remotePackage->reloadOwnRating();
}

void Package::setRemotePackage(QPndman::Package* p)
{
  if(p != remotePackage)
  {
    applicationList.clear();
    titleList.clear();
    descriptionList.clear();
    categoryList.clear();
    previewPictureList.clear();

    remotePackage = p;
    if(remotePackage)
    {
      connect(remotePackage, SIGNAL(commentsChanged()), this, SLOT(handleCommentUpdate()));
      connect(remotePackage, SIGNAL(reloadCommentsDone()), this, SIGNAL(reloadCommentsDone()));
      connect(remotePackage, SIGNAL(addCommentDone()), this, SIGNAL(addCommentDone()));
      connect(remotePackage, SIGNAL(addCommentFail()), this, SIGNAL(addCommentFail()));
      connect(remotePackage, SIGNAL(deleteCommentDone()), this, SIGNAL(deleteCommentDone()));
      connect(remotePackage, SIGNAL(deleteCommentFail()), this, SIGNAL(deleteCommentFail()));
      connect(remotePackage, SIGNAL(rateDone()), this, SIGNAL(rateDone()));
      connect(remotePackage, SIGNAL(rateFail()), this, SIGNAL(rateFail()));
      connect(remotePackage, SIGNAL(ratingChanged()), this, SIGNAL(ratingChanged()));
      connect(remotePackage, SIGNAL(ownRatingChanged()), this, SIGNAL(ownRatingChanged()));
    }
  }
}

void Package::setLocalPackage(QPndman::Package* p)
{
  applicationList.clear();
  titleList.clear();
  descriptionList.clear();
  categoryList.clear();
  previewPictureList.clear();

  QPndman::Package* old = localPackage;
  localPackage = p;

  if((localPackage != 0) != (old != 0) || (localPackage && old && (old->getUpgradeCandidate() != 0) != (localPackage->getUpgradeCandidate() != 0)))
    emit hasUpgradeChanged();

  if((localPackage && !old) || (!localPackage && old))
    emit installedChanged(localPackage != 0);
}

bool Package::getIsForeign() const
{
  return remotePackage == 0;
}

QImage Package::getEmbeddedIcon() const
{
  if(!localPackage)
  {
    return QImage();
  }

  return localPackage->getEmbeddedIcon();
}

void Package::addComment(const QString comment)
{
  if(remotePackage)
  {
    remotePackage->addComment(comment);
  }
}

void Package::deleteComment(QPndman::Comment* comment)
{
  if(remotePackage)
  {
    remotePackage->deleteComment(comment);
  }
}

void Package::rate(const int rating)
{
  if(remotePackage)
  {
    remotePackage->rate(rating);
  }
}

QPndman::Package *Package::rPackage() const
{
  return remotePackage ? remotePackage.data() : localPackage ? localPackage.data() : 0;
}

QPndman::Package *Package::lPackage() const
{
  return localPackage ? localPackage.data() : remotePackage ? remotePackage.data() : 0;
}
