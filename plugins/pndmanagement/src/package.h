#ifndef PNDMANAGER_PACKAGE_H
#define PNDMANAGER_PACKAGE_H

#include "qtpndman.h"
#include <QtDeclarative>
#include <QList>

class PNDManager;

class Package : public QPndman::Package
{
  Q_OBJECT
  Q_PROPERTY(bool installed READ getInstalled NOTIFY installedChanged)
  Q_PROPERTY(bool hasUpgrade READ getHasUpgrade NOTIFY hasUpgradeChanged)
  Q_PROPERTY(bool isDownloading READ getIsDownloading NOTIFY bytesDownloadedChanged)
  Q_PROPERTY(qint64 bytesDownloaded READ getBytesDownloaded NOTIFY bytesDownloadedChanged)
  Q_PROPERTY(qint64 bytesToDownload READ getBytesToDownload NOTIFY bytesToDownloadChanged)

public:
  Package(PNDManager* manager, QPndman::Package const& p, bool installed, QObject* parent = 0);

  Package(QObject* parent = 0);
  Package(Package const& other);
  Package& operator=(Package const& other);

  bool getInstalled() const;
  qint64 getBytesDownloaded() const;
  qint64 getBytesToDownload() const;
  bool getHasUpgrade() const;
  bool getIsDownloading() const;
  void updateFrom(QPndman::Package package);
  QPndman::UpgradeHandle* upgradePackage(bool force = false);

public slots:
  void setInstalled();
  void setInstalled(bool);
  void setBytesDownloaded(qint64);
  void setBytesToDownload(qint64);

  // TODO: ugly QString, Qt 4.7 doesn't allow enums in slot parameters yet :(
  void install(QObject* device, QString installLocation);
  void remove();
  void upgrade();

signals:
  void installedChanged(bool);
  void bytesDownloadedChanged(qint64);
  void bytesToDownloadChanged(qint64);
  void hasUpgradeChanged();
  
private:
  PNDManager* manager;
  bool installed;
  qint64 bytesDownloaded;
  qint64 bytesToDownload;
};

QML_DECLARE_TYPE(Package)
#endif
