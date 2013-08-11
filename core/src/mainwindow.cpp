#include "mainwindow.h"
#include <QQmlContext>
#include <QQmlEngine>

#ifdef ENABLE_OPENGL
#include <QGLWidget>
#endif
#include <QGuiApplication>
#include <QDir>

MainWindow::MainWindow(QWindow *parent) :
        QQuickView(parent), _runtimeObject(this)
{
    //Set the runtime object context property
    rootContext()->setContextProperty("runtime", &_runtimeObject);
    connect(&_runtimeObject, SIGNAL(fullscreenRequested(bool)),
            this, SLOT(setFullscreen(bool)));
    connect(&_runtimeObject, SIGNAL(quit()), this, SLOT(close()));

    connect(&_runtimeObject, SIGNAL(mouseCursorVisibleChanged(bool)),
            this, SLOT(showMouseCursor(bool)));
/*
#ifdef ENABLE_OPENGL
    setViewport(new QGLWidget());
#endif
    viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    viewport()->setAttribute(Qt::WA_NoSystemBackground);
    viewport()->setAttribute(Qt::WA_PaintUnclipped);
    viewport()->setAttribute(Qt::WA_TranslucentBackground, false);

    setOptimizationFlag(QGraphicsView::DontAdjustForAntialiasing);
    setOptimizationFlag(QGraphicsView::DontSavePainterState);
    */
/*
    setFocusPolicy(Qt::StrongFocus);
    setResizeMode(QQuickView::SizeRootObjectToView);
    setStyleSheet("border-style: none;");
    setFrameStyle(0);
    setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
*/
    //Set up UI loading and channel quit() events from QML
    //connect(engine(), SIGNAL(quit()), this, SLOT(close()));

    setResizeMode(QQuickView::SizeViewToRootObject);
    //Make plugins available
    engine()->addImportPath(QGuiApplication::applicationDirPath() + "/plugins");
    engine()->addImportPath(PANORAMA_PREFIX "/lib/panorama/plugins");
    engine()->addImportPath(QDir::homePath() + "/.panorama/plugins");

    //Load the main QML file
    setSource(QUrl("qrc:/root.qml"));

    //Resize to default size
    resize(PANORAMA_UI_WIDTH, PANORAMA_UI_HEIGHT);
}

void MainWindow::changeEvent(QEvent *e)
{
    if(e->type() == QEvent::ActivationChange)
    {
        //_runtimeObject.setIsActiveWindow(isActiveWindow());
    }
    //QDeclarativeView::changeEvent(e);
}

void MainWindow::setFullscreen(bool fullscreen)
{
    /*if(fullscreen)
        setWindowState(windowState() | Qt::WindowFullScreen);
    else
      setWindowState(windowState() & ~Qt::WindowFullScreen);*/
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
