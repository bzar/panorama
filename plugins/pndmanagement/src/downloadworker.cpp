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
    if(!context->processDownload())
    {
      msleep(500);
    }
    stopMutex.unlock();
  }
}

void DownloadWorker::stop()
{
  stopMutex.lock();
  wait();
  stopMutex.unlock();
}
