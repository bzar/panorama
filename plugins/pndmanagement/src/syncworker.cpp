#include "syncworker.h"

#include <QApplication>
#include <QDebug>

SyncWorker::SyncWorker(QPndman::SyncHandle* handle) : handle(handle), syncStarted(false), timer()
{
  connect(SyncWorkerSingleton::instance(), SIGNAL(error()), this, SLOT(emitError()), Qt::QueuedConnection);
  timer.setInterval(500);
  timer.setSingleShot(false);
  connect(&timer, SIGNAL(timeout()), this, SLOT(process()));
}

void SyncWorker::start()
{
  qDebug() << "SyncWorker::start";
  QMetaObject::invokeMethod(SyncWorkerSingleton::instance(), "start", Qt::QueuedConnection);
  timer.start();
}

void SyncWorker::process()
{
  handle->update();

  if(!syncStarted && handle->getBytesDownloaded() > 0)
  {
    syncStarted = true;
    emit started(handle);
  }
  if(handle->getDone())
  {
    qDebug() << "SyncWorker::process -> ready";
    emit ready(handle);
    deleteLater();
  }
}

void SyncWorker::emitError()
{
  emit error(handle);
}

SyncWorkerSingletonThread* SyncWorkerSingleton::thread = 0;

SyncWorkerSingleton *SyncWorkerSingleton::instance()
{
  if(thread == 0)
  {
    thread = new SyncWorkerSingletonThread(QApplication::instance());
    thread->start(QThread::LowPriority);
    while(thread->getSingleton() == 0) {
      QThread::yieldCurrentThread();
    }
  }
  return thread->getSingleton();
  /*static SyncWorkerSingleton* singleton = new SyncWorkerSingleton(QApplication::instance());
  return singleton;*/
}

SyncWorkerSingleton::~SyncWorkerSingleton()
{
}

void SyncWorkerSingleton::start()
{
  timer.start();
}

SyncWorkerSingleton::SyncWorkerSingleton(QObject *parent) : QObject(parent), timer()
{
  qDebug() << "SyncWorkerSingleton::SyncWorkerSingleton";
  timer.setInterval(100);
  timer.setSingleShot(false);
  connect(&timer, SIGNAL(timeout()), this, SLOT(process()));
}

void SyncWorkerSingleton::process()
{
  int status = QPndman::SyncHandle::sync();
  if(status == 0)
  {
    timer.stop();
  }
  else if(status <= 0)
  {
    timer.stop();
    emit error();
  }
}


SyncWorkerSingletonThread::SyncWorkerSingletonThread(QObject *parent) : QThread(parent), singleton(0)
{
  connect(QApplication::instance(), SIGNAL(aboutToQuit()), this, SLOT(quit()));
}

SyncWorkerSingletonThread::~SyncWorkerSingletonThread()
{
}

void SyncWorkerSingletonThread::run()
{
  singleton = new SyncWorkerSingleton();
  exec();
  delete singleton;
  singleton = 0;
}

SyncWorkerSingleton *SyncWorkerSingletonThread::getSingleton() const
{
  return singleton;
}
