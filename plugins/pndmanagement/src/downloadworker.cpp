#include "downloadworker.h"
#include <QDebug>

DownloadWorker::DownloadWorker(QPndman::Context *context) : context(context), stopMutex()
{
  stopMutex.lock();
}

void DownloadWorker::run()
{
  stopMutex.unlock();
  while(stopMutex.tryLock())
  {
    int pending = context->processDownload();
    stopMutex.unlock();
    msleep(pending ? 100 : 500);
  }
}

void DownloadWorker::stop()
{
  stopMutex.lock();
  wait();
  stopMutex.unlock();
}
