#include "systeminformationplugin.h"
#include "systeminformation.h"

void SystemInformationPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<SystemInformation>(uri, 1, 0, "SystemInformation");
}
