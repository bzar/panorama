#include "pndmanagementplugin.h"
#include "pndmanager.h"
#include "pndfilter.h"
#include "package.h"

void PNDManagementPlugin::registerTypes(const char *uri)
{
  qmlRegisterType<PNDManager>(uri, 1, 0, "PNDManager");
  qmlRegisterType<Package>(uri, 1, 0, "PNDPackage");
  qmlRegisterType<PNDFilter>(uri, 1, 0, "PNDFilter");
  qmlRegisterType<QPndman::Device>(uri, 1, 0, "Device");
  qmlRegisterType<QPndman::Version>(uri, 1, 0, "Version");
}

Q_EXPORT_PLUGIN2(pndmanagement,PNDManagementPlugin);
