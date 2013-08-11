#include "pndmanagementplugin.h"
#include "pndmanager.h"
#include "pndfilter.h"
#include "package.h"
#include "pndutils.h"
#include "pnddeclarativeimageprovider.h"

void PNDManagementPlugin::registerTypes(const char *uri)
{
  // @uri Panorama.PNDManagement
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
  qmlRegisterType<QPndman::Comment>();
}

void PNDManagementPlugin::initializeEngine(QQmlEngine* engine, const char *uri)
{
  Q_UNUSED(uri)
  engine->addImageProvider("pnd", new PNDDeclarativeImageProvider);
}

QML_DECLARE_TYPE(QPndman::Version)

