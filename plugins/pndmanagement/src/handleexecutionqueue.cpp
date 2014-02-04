#include "handleexecutionqueue.h"

HandleExecutionQueue::HandleExecutionQueue(QObject* parent) :
  QObject(parent), handles(), maxExecuting(DEFAULT_MAX_EXECUTING),
  currentlyExecuting(0)
{
}

bool HandleExecutionQueue::enqueue(QPndman::Handle* handle)
{
  connect(handle, SIGNAL(done()), this, SLOT(handleReady()));
  connect(handle, SIGNAL(cancelled()), this, SLOT(handleReady()));
  connect(handle, SIGNAL(error(QString)), this, SLOT(handleReady()));

  if(currentlyExecuting < maxExecuting)
  {
    execute(handle);
    return false;
  }
  else
  {
    handles.enqueue(handle);
    return true;
  }
}
int HandleExecutionQueue::getMaxExecuting() const
{
  return maxExecuting;
}

void HandleExecutionQueue::setMaxExecuting(int value)
{
  if(maxExecuting != value)
  {
    maxExecuting = value;
    emit maxExecutingChanged();
  }
}
int HandleExecutionQueue::getCurrentlyExecuting() const
{
  return currentlyExecuting;
}

void HandleExecutionQueue::handleReady()
{
  QPndman::Handle* queuedHandle = 0;
  foreach(QPndman::Handle* handle, handles)
  {
    if(handle->getCancelled())
    {
      queuedHandle = handle;
      break;
    }
  }

  if(queuedHandle == 0)
  {
    --currentlyExecuting;
  }
  else
  {
    handles.removeOne(queuedHandle);
  }

  if(currentlyExecuting < maxExecuting && !handles.empty())
  {
    execute(handles.dequeue());
  }
}

void HandleExecutionQueue::execute(QPndman::Handle* handle)
{
  if(handle->execute())
  {
    ++currentlyExecuting;
  }
}
