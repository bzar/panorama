#ifndef PNDMANAGEMENT_PNDMANAGER_H
#define PNDMANAGEMENT_PNDMANAGER_H

#include <QObject>
#include <QMap>
#include <QList>
#include "qtpndman.h"
#include "package.h"
#include "pndfilter.h"

class PNDManager : public QObject
{
  Q_OBJECT
  Q_PROPERTY(PNDFilter* packages READ getPackagesQObject NOTIFY packagesChanged)
  Q_PROPERTY(QList<QObject*> devices READ getDevices NOTIFY devicesChanged)
public:
  PNDManager(QObject* parent = 0);
  ~PNDManager();

  Q_INVOKABLE QList<QObject*> getDevices();
  Q_INVOKABLE QList<Package*> getPackages();
  Q_INVOKABLE PNDFilter* getPackagesQObject();

public slots:
  void crawl();
  void sync();
  void install(Package* package, QPndman::Device* device, QPndman::Enum::InstallLocation location);
  void remove(Package* package);
  void upgrade(Package* package);
  
signals:
  void packagesChanged();
  void devicesChanged();
  void installing(Package* package);
  void upgrading(Package* package);
  void error(QString);
  void syncing(QPndman::SyncHandle* handle);
  void syncDone();
  void crawling();
  void crawlDone();

private slots:
  void updatePackages();
  
private:
  static QString const REPOSITORY_URL;
  
  QPndman::Context* context;
  QPndman::Repository* repository;
  QPndman::LocalRepository* localRepository;
  QPndman::Device* tmpDevice;

  QList<Package*> packages;
  QMap<QString, Package*> packagesById;
  QList<QPndman::Device*> devices;
};

#endif
