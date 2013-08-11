#include <QGuiApplication>
#include "mainwindow.h"

int main(int argc, char *argv[])
{
    //QGuiApplication::setGraphicsSystem("raster");


    //We don't have any args, but pass them on anyways for standard X.Org args
    //handling
    const QGuiApplication a(argc, argv);

    //Show the main window
    MainWindow w;
    w.show();

    //Run the event loop
    return a.exec();
}
