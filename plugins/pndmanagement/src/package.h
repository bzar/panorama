#ifndef PNDMANAGER_PACKAGE_H
#define PNDMANAGER_PACKAGE_H

#include "qtpndman.h"
#include <QtDeclarative>
#include <QList>
#include <QPointer>

class PNDManager;

class Package : public QObject
{
  Q_OBJECT

  Q_ENUMS(QPndman::Enum::InstallLocation)

  Q_PROPERTY(QString path READ getPath CONSTANT)
  Q_PROPERTY(QString id READ getId CONSTANT)
  Q_PROPERTY(QString icon READ getIcon CONSTANT)
  Q_PROPERTY(QString info READ getInfo CONSTANT)
  Q_PROPERTY(QString md5 READ getMd5 CONSTANT)
  Q_PROPERTY(QString url READ getUrl CONSTANT)
  Q_PROPERTY(QString vendor READ getVendor CONSTANT)
  Q_PROPERTY(QString mount READ getMount CONSTANT)
  Q_PROPERTY(qint64 size READ getSize CONSTANT)
  Q_PROPERTY(QDateTime modified READ getModified CONSTANT)
  Q_PROPERTY(int rating READ getRating CONSTANT)
  Q_PROPERTY(QPndman::Author* author READ getAuthor CONSTANT)
  Q_PROPERTY(QPndman::Version* localVersion READ getLocalVersion CONSTANT)
  Q_PROPERTY(QPndman::Version* remoteVersion READ getRemoteVersion CONSTANT)
  Q_PROPERTY(QString title READ getTitle CONSTANT)
  Q_PROPERTY(QString description READ getDescription CONSTANT)
  Q_PROPERTY(QPndman::Package* upgradeCandidate READ getUpgradeCandidate CONSTANT)
  Q_PROPERTY(QDeclarativeListProperty<QPndman::Application> applications READ getApplicationsProperty CONSTANT)
  Q_PROPERTY(QDeclarativeListProperty<QPndman::TranslatedString> titles READ getTitlesProperty CONSTANT)
  Q_PROPERTY(QDeclarativeListProperty<QPndman::TranslatedString> descriptions READ getDescriptionsProperty CONSTANT)
  Q_PROPERTY(QDeclarativeListProperty<QPndman::Category> categories READ getCategoriesProperty CONSTANT)
  Q_PROPERTY(QDeclarativeListProperty<QPndman::PreviewPicture> previewPictures READ getPreviewPicturesProperty CONSTANT)

  Q_PROPERTY(bool installed READ getInstalled NOTIFY installedChanged)
  Q_PROPERTY(bool hasUpgrade READ getHasUpgrade NOTIFY hasUpgradeChanged)
  Q_PROPERTY(bool isDownloading READ getIsDownloading NOTIFY bytesDownloadedChanged)
  Q_PROPERTY(qint64 bytesDownloaded READ getBytesDownloaded NOTIFY bytesDownloadedChanged)
  Q_PROPERTY(qint64 bytesToDownload READ getBytesToDownload NOTIFY bytesToDownloadChanged)

  Q_PROPERTY(QDeclarativeListProperty<QPndman::Comment> comments READ getCommentsProperty NOTIFY commentsChanged)

public:
  Package(PNDManager* manager, QPndman::Package* localPackage, QPndman::Package* remotePackage, QObject* parent = 0);

  QString getPath() const;
  QString getId() const;
  QString getIcon() const;
  QString getInfo() const;
  QString getMd5() const;
  QString getUrl() const;
  QString getVendor() const;
  QString getMount() const;
  qint64 getSize() const;
  QDateTime getModified() const;
  int getRating() const;
  QPndman::Author* getAuthor() const;
  QPndman::Version* getLocalVersion() const;
  QPndman::Version* getRemoteVersion() const;
  QString getTitle() const;
  QString getDescription() const;
  QPndman::Package* getUpgradeCandidate() const;

  QList<QPndman::Application*> getApplications() const;
  QList<QPndman::TranslatedString*> getTitles() const;
  QList<QPndman::TranslatedString*> getDescriptions() const;
  QList<QPndman::Category*> getCategories() const;
  QList<QPndman::PreviewPicture*> getPreviewPictures() const;
  QList<QPndman::Comment*> getComments() const;

  QDeclarativeListProperty<QPndman::Application> getApplicationsProperty();
  QDeclarativeListProperty<QPndman::TranslatedString> getTitlesProperty();
  QDeclarativeListProperty<QPndman::TranslatedString> getDescriptionsProperty();
  QDeclarativeListProperty<QPndman::Category> getCategoriesProperty();
  QDeclarativeListProperty<QPndman::PreviewPicture> getPreviewPicturesProperty();
  QDeclarativeListProperty<QPndman::Comment> getCommentsProperty();

  int applicationCount() const;
  int titleCount() const;
  int descriptionCount() const;
  int categoryCount() const;
  int previewPictureCount() const;
  int installInstanceCount() const;

  QPndman::Application* getApplication(int i) const;
  QPndman::TranslatedString* getTitle(int i) const;
  QPndman::TranslatedString* getDescription(int i) const;
  QPndman::Category* getCategory(int i) const;
  QPndman::PreviewPicture* getPreviewPicture(int i) const;

  bool getInstalled() const;
  qint64 getBytesDownloaded() const;
  qint64 getBytesToDownload() const;
  bool getHasUpgrade() const;
  bool getIsDownloading() const;
  void setRemotePackage(QPndman::Package* p);
  void setLocalPackage(QPndman::Package* p);

  QImage getEmbeddedIcon() const;

  Q_INVOKABLE void addComment(QString const comment);
  Q_INVOKABLE void rate(int const rating);

public slots:
  void setInstalled();
  void setBytesDownloaded(qint64);
  void setBytesToDownload(qint64);

  // TODO: ugly QString, Qt 4.7 doesn't allow enums in slot parameters yet :(
  void install(QPndman::Device* device, QString installLocation);
  void remove();
  void upgrade();
  void cancelDownload();
  void handleDownloadCancelled();

  void handleCommentUpdate();
  void reloadComments();

signals:
  void installedChanged(bool);
  void bytesDownloadedChanged(qint64);
  void bytesToDownloadChanged(qint64);
  void hasUpgradeChanged();
  void downloadCancelled();
  void downloadStarted();

  void commentsChanged();
  void reloadCommentsDone();
  void addCommentDone();

private:
  QPndman::Package* rPackage() const;
  QPndman::Package* lPackage() const;

  PNDManager* manager;
  QPointer<QPndman::Package> localPackage;
  QPointer<QPndman::Package> remotePackage;
  QPointer<QPndman::Handle> operationHandle;

  QString id;

  qint64 bytesDownloaded;
  qint64 bytesToDownload;

  QList<QPndman::Application*> applicationList;
  QList<QPndman::TranslatedString*> titleList;
  QList<QPndman::TranslatedString*> descriptionList;
  QList<QPndman::Category*> categoryList;
  QList<QPndman::PreviewPicture*> previewPictureList;
  QList<QPndman::Comment*> commentList;
};

#endif
