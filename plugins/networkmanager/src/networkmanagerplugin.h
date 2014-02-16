#ifndef NETWORKMANAGERPLUGIN_H
#define NETWORKMANAGERPLUGIN_H

#include <QtQuick>
#include <QQmlExtensionPlugin>

class NetworkManagerPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
public:
    void registerTypes(const char *uri);
};

#endif // NETWORKMANAGERPLUGIN_H
