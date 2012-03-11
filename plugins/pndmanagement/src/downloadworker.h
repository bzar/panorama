#ifndef DOWNLOADWORKER_H
#define DOWNLOADWORKER_H

#include "qtpndman.h"
#include <QTimer>
#include <QObject>
#include <QThread>

class DownloadWorker : public QObject
{
  Q_OBJECT
public:
  DownloadWorker(QPndman::Handle* handle);
  
public slots:
  void start();
  
private slots:
  void process();
  void emitError();

signals:
  void started(QPndman::Handle* handle);
  void ready(QPndman::Handle* handle);
  void error(QPndman::Handle* handle);
  
private:
  QPndman::Handle* handle;
  bool downloadStarted;
};

class DownloadWorkerSingletonThread;

class DownloadWorkerSingleton : public QObject
{
  Q_OBJECT
public:
  static DownloadWorkerSingleton* instance();
  ~DownloadWorkerSingleton();
public slots:
  void start();
signals:
  void update();
  void error();
private slots:
  void process();
private:
  friend class DownloadWorkerSingletonThread;
  static DownloadWorkerSingletonThread* thread;
  DownloadWorkerSingleton(QObject* parent = 0);
  QTimer timer;
};

class DownloadWorkerSingletonThread : public QThread
{
  Q_OBJECT
public:
  DownloadWorkerSingletonThread(QObject* parent = 0);
  void run();
  DownloadWorkerSingleton* getSingleton() const;
private:
  DownloadWorkerSingleton* singleton;
};

#endif
