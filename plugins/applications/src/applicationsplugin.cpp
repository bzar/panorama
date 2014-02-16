#include "applicationsplugin.h"

#include "applications.h"
#include "application.h"

void ApplicationsPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<Applications>(uri, 1, 0, "Applications");
    qRegisterMetaType<Application>("Application");
}
