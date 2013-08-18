#include "downloadworker.h"
#include <QDebug>

DownloadWorker::DownloadWorker(QPndman::Context *context) : QThread(), context(context), stopMutex()
{
  stopMutex.lock();
}

void DownloadWorker::run()
{
  stopMutex.unlock();
  while(stopMutex.tryLock())
  {
    int pending = context->processDownload();
    msleep(pending ? 10 : 1000);
    stopMutex.unlock();
    msleep(1); // Required, otherwise stop() never gets the lock
  }
}

void DownloadWorker::stop()
{
  stopMutex.lock();
  wait();
  stopMutex.unlock();
}
