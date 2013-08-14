#ifndef HANDLEEXECUTIONQUEUE_H
#define HANDLEEXECUTIONQUEUE_H

#include "qtpndman.h"
#include <QQueue>

class HandleExecutionQueue : public QObject
{
  Q_OBJECT

public:
  HandleExecutionQueue(QObject* parent = 0);
  bool enqueue(QPndman::Handle* handle);

  int getMaxExecuting() const;
  void setMaxExecuting(int value);

  int getCurrentlyExecuting() const;

signals:
  void maxExecutingChanged();

private slots:
  void handleReady();

private:
  static int const DEFAULT_MAX_EXECUTING = 2;
  void execute(QPndman::Handle* handle);

  QQueue<QPndman::Handle*> handles;
  int maxExecuting;
  int currentlyExecuting;
};

#endif // HANDLEEXECUTIONQUEUE_H
