#ifndef DOWNLOADWORKER_H
#define DOWNLOADWORKER_H

#include "qtpndman.h"
#include <QThread>
#include <QMutex>

class DownloadWorker : public QThread
{
  Q_OBJECT
public:
  DownloadWorker(QPndman::Context* context);
  void run();
  
public slots:
  void stop();
  
private:
  QPndman::Context* context;
  QMutex stopMutex;
};

#endif
