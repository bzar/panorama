#include <QGuiApplication>
#include <QCommandLineParser>
#include "mainwindow.h"
#include <QDebug>

int main(int argc, char *argv[])
{
    const QGuiApplication a(argc, argv);
    QCommandLineParser parser;

    // Define command line arguments
    parser.setApplicationDescription("A QtQuick based application runtime");
    parser.addHelpOption();

    parser.addPositionalArgument("ui", "User interface to run");

    // Process command line arguments
    parser.process(a);

    if(parser.positionalArguments().size() == 0)
    {
      parser.showHelp(1);
    }

    //Show the main window
    MainWindow w(parser.positionalArguments().at(0));
    w.show();

    //Run the event loop
    return a.exec();

}
