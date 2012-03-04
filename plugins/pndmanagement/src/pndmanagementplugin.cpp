#include "pndmanagementplugin.h"
#include "pndmanager.h"
#include "pndlistmodel.h"
#include "package.h"

void PNDManagementPlugin::registerTypes(const char *uri)
{
  qmlRegisterType<PNDManager>(uri, 1, 0, "PNDManager");
  qmlRegisterType<PNDListModel>(uri, 1, 0, "PNDListModel");
  qmlRegisterType<Package>(uri, 1, 0, "PNDPackage");
}

Q_EXPORT_PLUGIN2(pndmanagement,PNDManagementPlugin);
