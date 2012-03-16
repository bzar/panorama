#ifndef SYNCWORKER_H
#define SYNCWORKER_H

#include "qtpndman.h"
#include <QTimer>
#include <QObject>
#include <QThread>

class SyncWorker : public QObject
{
  Q_OBJECT
public:
  SyncWorker(QPndman::SyncHandle* handle);

public slots:
  void start();

private slots:
  void process();
  void emitError();

signals:
  void started(QPndman::SyncHandle* handle);
  void ready(QPndman::SyncHandle* handle);
  void error(QPndman::SyncHandle* handle);

private:
  QPndman::SyncHandle* handle;
  bool syncStarted;
  QTimer timer;
};

class SyncWorkerSingletonThread;

class SyncWorkerSingleton : public QObject
{
  Q_OBJECT
public:
  static SyncWorkerSingleton* instance();
  ~SyncWorkerSingleton();
public slots:
  void start();
signals:
  void update();
  void error();
private slots:
  void process();
private:
  friend class SyncWorkerSingletonThread;
  static SyncWorkerSingletonThread* thread;
  SyncWorkerSingleton(QObject* parent = 0);
  QTimer timer;
};

class SyncWorkerSingletonThread : public QThread
{
  Q_OBJECT
public:
  SyncWorkerSingletonThread(QObject* parent = 0);
  ~SyncWorkerSingletonThread();
  void run();
  SyncWorkerSingleton* getSingleton() const;
private:
  SyncWorkerSingleton* singleton;
};


#endif
