#include "pndmanagementplugin.h"
#include "pndmanager.h"
#include "pndfilter.h"
#include "package.h"
#include "pndutils.h"
//#include "pnddeclarativeimageprovider.h"

void PNDManagementPlugin::registerTypes(const char *uri)
{
  qmlRegisterType<PNDManager>(uri, 1, 0, "PNDManager");
  qmlRegisterType<PNDUtils>(uri, 1, 0, "PNDUtils");
  qmlRegisterType<Package>();
  qmlRegisterType<PNDFilter>();
  qmlRegisterType<QPndman::Device>();
  qmlRegisterType<QPndman::Version>();
  qmlRegisterType<QPndman::Package>();
  qmlRegisterType<QPndman::Author>();
  qmlRegisterType<QPndman::PreviewPicture>();
  qmlRegisterType<QPndman::DocumentationInfo>();
  qmlRegisterType<QPndman::License>();
  qmlRegisterType<QPndman::Category>();
  qmlRegisterType<QPndman::Association>();
  qmlRegisterType<QPndman::ExecutionInfo>();
  qmlRegisterType<QPndman::Application>();
}

void PNDManagementPlugin::initializeEngine(QDeclarativeEngine *engine, const char *uri)
{
  Q_UNUSED(uri)
  //TODO: Disabled until cached dowloading can be fixed
  //engine->addImageProvider("pnd", new PNDDeclarativeImageProvider);
}

Q_EXPORT_PLUGIN2(pndmanagement,PNDManagementPlugin)
