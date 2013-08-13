#include "settingsplugin.h"
#include "setting.h"

void SettingsPlugin::registerTypes(const char *uri)
{
    // @uri Panorama.Settings
    qmlRegisterType<Setting>(uri, 1, 0, "Setting");
}
