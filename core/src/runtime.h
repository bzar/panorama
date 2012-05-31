#ifndef RUNTIME_H
#define RUNTIME_H

#include <QObject>
#include <QtDeclarative>

class Runtime : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isActiveWindow READ isActiveWindow NOTIFY isActiveWindowChanged)
    Q_PROPERTY(bool mouseCursorVisible READ mouseCursorVisible WRITE setMouseCursorVisible NOTIFY mouseCursorVisibleChanged)

public:
    explicit Runtime(QObject *parent = 0);

    bool isActiveWindow() const;
    void setIsActiveWindow(bool value);

    bool mouseCursorVisible() const;
    void setMouseCursorVisible(bool value);

    Q_INVOKABLE void setFullscreen(bool value);

signals:
    void isActiveWindowChanged(bool value);
    void mouseCursorVisibleChanged(bool value);
    void fullscreenRequested(bool value);
    void quit();

private:
    bool _isActiveWindow;
    bool _mouseCursorVisible;
};

#endif // RUNTIME_H
