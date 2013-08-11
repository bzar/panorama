#ifndef PNDMANAGEMENTPLUGIN_H
#define PNDMANAGEMENTPLUGIN_H

#include <QtQuick>
#include <QQmlExtensionPlugin>
#include "qtpndman.h"

class PNDManagementPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
public:
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
};

#endif
