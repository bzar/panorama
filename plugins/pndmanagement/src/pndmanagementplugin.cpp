#include "pndmanagementplugin.h"
#include "pndmanager.h"
#include "pndfilter.h"
#include "package.h"
//#include "pnddeclarativeimageprovider.h"

void PNDManagementPlugin::registerTypes(const char *uri)
{
  qmlRegisterType<PNDManager>(uri, 1, 0, "PNDManager");
  qmlRegisterType<Package>();
  qmlRegisterType<PNDFilter>();
  qmlRegisterType<QPndman::Device>();
  qmlRegisterType<QPndman::Version>();
  qmlRegisterType<QPndman::Package>();
}

void PNDManagementPlugin::initializeEngine(QDeclarativeEngine *engine, const char *uri)
{
  Q_UNUSED(uri)
  //TODO: Disabled until cached dowloading can be fixed
  //engine->addImageProvider("pnd", new PNDDeclarativeImageProvider);
}

Q_EXPORT_PLUGIN2(pndmanagement,PNDManagementPlugin)
