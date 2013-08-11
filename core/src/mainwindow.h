#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QQuickView>
#include <QUrl>
#include <QFile>
#include <QKeyEvent>

#include "panoramaconfig.h"
#include "runtime.h"

/**
 * A MainWindow that is capable of displaying the Panorama's GUI
 */
class MainWindow : public QQuickView
{
    Q_OBJECT

public:
    /** Constructs a new MainWindow instance */
    MainWindow(QWindow* parent = 0);

protected:
    void changeEvent(QEvent* e);

private slots:
    void setFullscreen(bool fullscreen);
    void showMouseCursor(bool value);

private:
    Runtime _runtimeObject;
};

#endif // MAINWINDOW_H
