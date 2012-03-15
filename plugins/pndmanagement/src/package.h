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
  Q_PROPERTY(QString device READ getDevice CONSTANT)
  Q_PROPERTY(qint64 size READ getSize CONSTANT)
  Q_PROPERTY(QDateTime modified READ getModified CONSTANT)
  Q_PROPERTY(int rating READ getRating CONSTANT)
  Q_PROPERTY(QPndman::Author* author READ getAuthor CONSTANT)
  Q_PROPERTY(QPndman::Version* version READ getVersion CONSTANT)
  Q_PROPERTY(QList<QPndman::Application*> applications READ getApplications CONSTANT)
  Q_PROPERTY(QList<QPndman::TranslatedString*> titles READ getTitles CONSTANT)
  Q_PROPERTY(QString title READ getTitle CONSTANT)
  Q_PROPERTY(QList<QPndman::TranslatedString*> descriptions READ getDescriptions CONSTANT)
  Q_PROPERTY(QString description READ getDescription CONSTANT)
  Q_PROPERTY(QList<QPndman::Category*> categories READ getCategories CONSTANT)
  Q_PROPERTY(QList<QPndman::Package*> installInstances READ getInstallInstances CONSTANT)
  Q_PROPERTY(QPndman::Package* upgradeCandidate READ getUpgradeCandidate CONSTANT)

  Q_PROPERTY(bool installed READ getInstalled NOTIFY installedChanged)
  Q_PROPERTY(bool hasUpgrade READ getHasUpgrade NOTIFY hasUpgradeChanged)
  Q_PROPERTY(bool isDownloading READ getIsDownloading NOTIFY bytesDownloadedChanged)
  Q_PROPERTY(qint64 bytesDownloaded READ getBytesDownloaded NOTIFY bytesDownloadedChanged)
  Q_PROPERTY(qint64 bytesToDownload READ getBytesToDownload NOTIFY bytesToDownloadChanged)
  Q_PROPERTY(QString pndIcon READ getPNDIcon CONSTANT)

public:
  Package(PNDManager* manager, QPndman::Package* p, bool installed, QObject* parent = 0);

  QString getPath() const;
  QString getId() const;
  QString getIcon() const;
  QString getInfo() const;
  QString getMd5() const;
  QString getUrl() const;
  QString getVendor() const;
  QString getDevice() const;
  qint64 getSize() const;
  QDateTime getModified() const;
  int getRating() const;
  QPndman::Author* getAuthor() const;
  QPndman::Version* getVersion() const;
  QList<QPndman::Application*> getApplications() const;
  QList<QPndman::TranslatedString*> getTitles() const;
  QString getTitle() const;
  QList<QPndman::TranslatedString*> getDescriptions() const;
  QString getDescription() const;
  QList<QPndman::Category*> getCategories() const;
  QList<QPndman::Package*> getInstallInstances() const;
  QPndman::Package* getUpgradeCandidate() const;

  bool getInstalled() const;
  qint64 getBytesDownloaded() const;
  qint64 getBytesToDownload() const;
  bool getHasUpgrade() const;
  bool getIsDownloading() const;
  void updateFrom(QPndman::Package* other);

public slots:
  void setInstalled();
  void setInstalled(bool);
  void setBytesDownloaded(qint64);
  void setBytesToDownload(qint64);

  QString getPNDIcon() const;

  // TODO: ugly QString, Qt 4.7 doesn't allow enums in slot parameters yet :(
  void install(QPndman::Device* device, QString installLocation);
  void remove();
  void upgrade();

signals:
  void installedChanged(bool);
  void bytesDownloadedChanged(qint64);
  void bytesToDownloadChanged(qint64);
  void hasUpgradeChanged();
  
private:
  PNDManager* manager;
  QPointer<QPndman::Package> package;

  QString id;

  bool installed;
  qint64 bytesDownloaded;
  qint64 bytesToDownload;
};

#endif
