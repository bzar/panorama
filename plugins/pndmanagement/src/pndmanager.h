#ifndef PNDMANAGEMENT_PNDMANAGER_H
#define PNDMANAGEMENT_PNDMANAGER_H

#include <QObject>
#include <QMap>
#include <QList>
#include "qtpndman.h"
#include "package.h"
#include "pndfilter.h"
#include "downloadworker.h"
#include "handleexecutionqueue.h"
#include <QDeclarativeListProperty>

class PNDManager : public QObject
{
  Q_OBJECT
  Q_PROPERTY(PNDFilter* packages READ getPackages NOTIFY packagesChanged)
  Q_PROPERTY(QDeclarativeListProperty<QPndman::Device> devices READ getDevices NOTIFY devicesChanged)
  Q_PROPERTY(QList<QString> customDevices READ getCustomDevices WRITE setCustomDevices)

  Q_PROPERTY(int verbosity READ getVerbosity WRITE setVerbosity NOTIFY verbosityChanged)
  Q_PROPERTY(bool applicationRunning READ getApplicationRunning NOTIFY applicationRunningChanged)

  Q_PROPERTY(QString username READ getUsername WRITE setUsername NOTIFY usernameChanged)
  Q_PROPERTY(QString key READ getKey WRITE setKey NOTIFY keyChanged)

  Q_PROPERTY(int maxDownloads READ getMaxDownloads WRITE setMaxDownloads NOTIFY maxDownloadsChanged)

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

  int getMaxDownloads() const;
  void setMaxDownloads(int value);

  bool getApplicationRunning() const;

  QString getUsername() const;
  QString getKey() const;

  void setUsername(QString const newUsername);
  void setKey(QString const newKey);

  bool enqueueHandle(QPndman::Handle* handle);

  QList<QString> getCustomDevices() const;
  void setCustomDevices(const QList<QString>& value);


public slots:
  void crawl();
  void crawl(QString packageId);
  void sync();
  void updatePackages();
  void saveRepositories();
  void execute(QString const& pndId);
  void setCustomDevicesString(QString const& value);

signals:
  void packagesChanged();
  void devicesChanged();
  void error(QString);
  void syncing(QPndman::SyncHandle* handle);
  void syncDone();
  void syncError();
  void crawling();
  void crawlDone();
  void downloadStarted();
  void downloadEnqueued();
  void downloadError();

  void verbosityChanged(int);
  void applicationRunningChanged(bool);

  void usernameChanged();
  void keyChanged();
  void maxDownloadsChanged();

private slots:
  void applicationStarted();
  void applicationFinished();
  void syncFinished();
  void login();
  void updateDevices();

private:
  static QString const REPOSITORY_URL;

  QPndman::Context* context;
  QPndman::Repository* repository;
  QPndman::LocalRepository* localRepository;

  QList<Package*> packages;
  QMap<QString, Package*> packagesById;
  QList<QString> customDevices;
  QList<QPndman::Device*> devices;
  QList<QPndman::Device*> commitableDevices;

  DownloadWorker downloadWorker;
  HandleExecutionQueue downloadQueue;
  QProcess runningApplication;
  bool applicationRunning;

  QString username;
  QString key;
};

#endif
