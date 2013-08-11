#ifndef SYSTEMINFORMATIONPLUGIN_H
#define SYSTEMINFORMATIONPLUGIN_H

#include <QQmlExtensionPlugin>

class SystemInformationPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
public:
    void registerTypes(const char *uri);
};

#endif // SYSTEMINFORMATIONPLUGIN_H
