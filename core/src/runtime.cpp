#include "runtime.h"

Runtime::Runtime(QObject *parent) :
  QObject(parent), _isActiveWindow(false), _mouseCursorVisible(true)
{
}

bool Runtime::isActiveWindow() const
{
    return _isActiveWindow;
}

void Runtime::setIsActiveWindow(bool const value)
{
    if(_isActiveWindow != value)
    {
        _isActiveWindow = value;
        emit isActiveWindowChanged(value);
    }
}

bool Runtime::mouseCursorVisible() const
{
    return _mouseCursorVisible;
}

void Runtime::setMouseCursorVisible(bool const value)
{
    if(_mouseCursorVisible != value)
    {
        _mouseCursorVisible = value;
        emit mouseCursorVisibleChanged(value);
    }
}

void Runtime::setFullscreen(bool fullscreen)
{
    emit fullscreenRequested(fullscreen);
}
