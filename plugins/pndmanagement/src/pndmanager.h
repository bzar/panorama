#ifndef PNDMANAGEMENT_PNDMANAGER_H
#define PNDMANAGEMENT_PNDMANAGER_H

#include <QObject>
#include <QMap>
#include <QList>
#include "qtpndman.h"
#include "package.h"
#include "pndfilter.h"
#include "downloadworker.h"
#include <QDeclarativeListProperty>

class PNDManager : public QObject
{
  Q_OBJECT
  Q_PROPERTY(PNDFilter* packages READ getPackages NOTIFY packagesChanged)
  Q_PROPERTY(QDeclarativeListProperty<QPndman::Device> devices READ getDevices NOTIFY devicesChanged)
  Q_PROPERTY(int verbosity READ getVerbosity WRITE setVerbosity NOTIFY verbosityChanged)
  Q_PROPERTY(bool applicationRunning READ getApplicationRunning NOTIFY applicationRunningChanged)

  Q_ENUMS(QPndman::Enum::InstallLocation QPndman::Enum::Operation QPndman::Version::Type)
public:
  PNDManager(QObject* parent = 0);
  ~PNDManager();

  QDeclarativeListProperty<QPndman::Device> getDevices();
  int deviceCount() const;
  QPndman::Device* getDevice(int) const;

  PNDFilter* getPackages();
  Package* getPackageById(QString const& id);

  Q_INVOKABLE PNDFilter* searchPackages(QString const& search);
  QPndman::Context* getContext() const;
  void addCommitableDevice(QPndman::Device* device);

  int getVerbosity() const;
  void setVerbosity(int level);

  bool getApplicationRunning() const;

public slots:
  void crawl();
  void sync();
  void updatePackages();
  void saveRepositories();
  void execute(QString const& pndId);

signals:
  void packagesChanged();
  void devicesChanged();
  void error(QString);
  void syncing(QPndman::SyncHandle* handle);
  void syncDone();
  void crawling();
  void crawlDone();
  void downloadStarted();

  void verbosityChanged(int);
  void applicationRunningChanged(bool);

private slots:
  void applicationStarted();
  void applicationFinished();
  void syncFinished();
private:
  static QString const REPOSITORY_URL;
  
  QPndman::Context* context;
  QPndman::Repository* repository;
  QPndman::LocalRepository* localRepository;

  QList<Package*> packages;
  QMap<QString, Package*> packagesById;
  QList<QPndman::Device*> devices;
  QList<QPndman::Device*> commitableDevices;

  DownloadWorker downloadWorker;
  QProcess runningApplication;
  bool applicationRunning;
};

#endif
