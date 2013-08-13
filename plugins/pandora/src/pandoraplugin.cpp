#include "pandoraplugin.h"
#include "pandora.h"

void PandoraPlugin::registerTypes(const char *uri)
{
    // @uri Panorama.Pandora
    qmlRegisterType<Pandora>(uri,1,0,"Pandora");
}

