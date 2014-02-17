#include "mainwindow.h"
#include <QQmlEngine>
#include <QQmlContext>
#include <QGuiApplication>
#include <QDir>
#include <QDebug>


MainWindow::MainWindow(const QString uiPath, QWindow *parent) :
        QQuickView(parent), _runtimeObject(this)
{
    // Set uiPath context property
    QDir uiDir(uiPath);
    rootContext()->setContextProperty("uiPath", QVariant(uiDir.absolutePath()));

    // Set the runtime object context property
    rootContext()->setContextProperty("runtime", &_runtimeObject);
    connect(&_runtimeObject, SIGNAL(fullscreenRequested(bool)),
            this, SLOT(setFullscreen(bool)));
    connect(&_runtimeObject, SIGNAL(quit()), this, SLOT(close()));

    connect(&_runtimeObject, SIGNAL(mouseCursorVisibleChanged(bool)),
            this, SLOT(showMouseCursor(bool)));

    //Make plugins available
    engine()->addImportPath(QGuiApplication::applicationDirPath() + "/plugins");
    engine()->addImportPath(PANORAMA_PREFIX "/lib/panorama/plugins");
    engine()->addImportPath(QDir::homePath() + "/.panorama/plugins");

    //Load the main QML file
    setSource(QUrl("qrc:/root.qml"));

    //Resize to default size
    setResizeMode(QQuickView::SizeRootObjectToView);
    resize(PANORAMA_UI_WIDTH, PANORAMA_UI_HEIGHT);
}

void MainWindow::focusInEvent(QFocusEvent* ev)
{
  _runtimeObject.setIsActiveWindow(ev->gotFocus());
  QQuickView::focusInEvent(ev);
}

void MainWindow::focusOutEvent(QFocusEvent* ev)
{
  _runtimeObject.setIsActiveWindow(ev->gotFocus());
  QQuickView::focusOutEvent(ev);
}

void MainWindow::setFullscreen(bool fullscreen)
{
    if(fullscreen)
    {
      showFullScreen();
    }
    else
    {
      showNormal();
    }
}

void MainWindow::showMouseCursor(bool value)
{
  if(value)
  {
    QGuiApplication::setOverrideCursor(QCursor(Qt::ArrowCursor));
  }
  else
  {
    QGuiApplication::setOverrideCursor(QCursor(Qt::BlankCursor));
  }
}
