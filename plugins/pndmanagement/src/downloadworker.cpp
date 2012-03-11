#include "downloadworker.h"
#include <QDebug>
#include <QApplication>

DownloadWorker::DownloadWorker(QPndman::Handle* handle) : handle(handle), downloadStarted(false), timer()
{
  //connect(DownloadWorkerSingleton::instance(), SIGNAL(update()), this, SLOT(process()), Qt::QueuedConnection);
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

DownloadWorkerSingleton::DownloadWorkerSingleton(QObject *parent) : QObject(parent), timer()
{
  qDebug() << "DownloadWorkerSingleton::DownloadWorkerSingleton";
  timer.setInterval(100);
  timer.setSingleShot(false);
  connect(&timer, SIGNAL(timeout()), this, SLOT(process()));
}

void DownloadWorkerSingleton::process()
{
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
}


DownloadWorkerSingletonThread::DownloadWorkerSingletonThread(QObject *parent) : QThread(parent), singleton(0)
{
  connect(QApplication::instance(), SIGNAL(aboutToQuit()), this, SLOT(terminate()));
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

  
