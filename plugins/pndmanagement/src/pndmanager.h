#ifndef PNDMANAGEMENT_PNDMANAGER_H
#define PNDMANAGEMENT_PNDMANAGER_H

#include <QObject>
#include <QMap>
#include <QList>
#include "qtpndman.h"
#include "package.h"
#include "pndlistmodel.h"

class PNDManager : public QObject
{
  Q_OBJECT
  Q_PROPERTY(PNDListModel* list READ getList NOTIFY listChanged)
  Q_PROPERTY(QList<QObject*> packages READ getPackagesQObject NOTIFY packagesChanged)

public:
  PNDManager(QObject* parent = 0);
  ~PNDManager();

  Q_INVOKABLE QList<QPndman::Device*> getDevices();
  Q_INVOKABLE QList<Package*> getPackages();
  Q_INVOKABLE QList<QObject*> getPackagesQObject();
  Q_INVOKABLE QList<QObject*> getPackagesFromCategory(QString categoryFilter);
  Q_INVOKABLE PNDListModel* getList();
  
public slots:
  void crawl();
  void sync();
  void install(Package* package, QPndman::Device* device, QPndman::InstallLocation location);
  void remove(Package* package);
  void upgrade(Package* package);
  
signals:
  void packagesChanged(QList<Package*> const& packages);
  void installing(Package* package, QPndman::Handle* handle);
  void upgrading(Package* package, QPndman::Handle* handle);
  void error(QString);
  void syncing(QPndman::SyncHandle* handle);
  void syncDone();
  void crawling();
  void crawlDone();
  
  void listChanged();
  
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
