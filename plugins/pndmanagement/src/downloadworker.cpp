#include "downloadworker.h"
#include <QDebug>
#include <QApplication>

DownloadWorker::DownloadWorker(QPndman::Handle* handle) : handle(handle), downloadStarted(false), timer()
{
  connect(DownloadWorkerSingleton::instance(), SIGNAL(error()), this, SLOT(emitError()), Qt::QueuedConnection);
  timer.setInterval(500);
  timer.setSingleShot(false);
  connect(&timer, SIGNAL(timeout()), this, SLOT(process()));
}

void DownloadWorker::start()
{
  qDebug() << "DownloadWorker::start";
  QMetaObject::invokeMethod(DownloadWorkerSingleton::instance(), "start", Qt::QueuedConnection);
  timer.start();
}
  
void DownloadWorker::process()
{
  DownloadWorkerSingleton::instance()->mutex.acquire();
  handle->update();
  
  if(!downloadStarted && handle->getBytesDownloaded() > 0)
  {
    downloadStarted = true;
    emit started(handle);
  }
  if(handle->getDone())
  {
    qDebug() << "DownloadWorker::process -> ready";
    emit ready(handle);
    deleteLater();
  }
  DownloadWorkerSingleton::instance()->mutex.release();
}

void DownloadWorker::emitError()
{
  emit error(handle);
}

DownloadWorkerSingletonThread* DownloadWorkerSingleton::thread = 0;

DownloadWorkerSingleton *DownloadWorkerSingleton::instance()
{
  if(thread == 0)
  {
    thread = new DownloadWorkerSingletonThread(QApplication::instance());
    thread->start(QThread::LowPriority);
    while(thread->getSingleton() == 0) {
      QThread::yieldCurrentThread();
    }
  }
  return thread->getSingleton();
}

DownloadWorkerSingleton::~DownloadWorkerSingleton()
{
}

void DownloadWorkerSingleton::start()
{
  timer.start();
}

DownloadWorkerSingleton::DownloadWorkerSingleton(QObject *parent) : QObject(parent), mutex(1), timer()
{
  qDebug() << "DownloadWorkerSingleton::DownloadWorkerSingleton";
  timer.setInterval(100);
  timer.setSingleShot(false);
  connect(&timer, SIGNAL(timeout()), this, SLOT(process()));
}

void DownloadWorkerSingleton::process()
{
  mutex.acquire();
  int status = QPndman::Handle::download();
  emit update();
  if(status == 0)
  {
    timer.stop();
  }
  else if(status <= 0)
  {
    timer.stop();
    emit error();
  }
  mutex.release();
}


DownloadWorkerSingletonThread::DownloadWorkerSingletonThread(QObject *parent) : QThread(parent), singleton(0)
{
  connect(QApplication::instance(), SIGNAL(aboutToQuit()), this, SLOT(quit()));
}

DownloadWorkerSingletonThread::~DownloadWorkerSingletonThread()
{
}

void DownloadWorkerSingletonThread::run()
{
  singleton = new DownloadWorkerSingleton();
  exec();
  delete singleton;
  singleton = 0;
}

DownloadWorkerSingleton *DownloadWorkerSingletonThread::getSingleton() const
{
  return singleton;
}

  
