#ifndef SETTINGSPLUGIN_H
#define SETTINGSPLUGIN_H

#include <QQmlExtensionPlugin>
#include <QtQuick>

class SettingsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri);
};

#endif // SETTINGSPLUGIN_H
