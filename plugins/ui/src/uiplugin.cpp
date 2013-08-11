#include "uiplugin.h"
#include "panoramaui.h"

void UIPlugin::registerTypes(const char *uri)
{
    // @uri Panorama.UI
    qmlRegisterType<PanoramaUI>(uri, 1, 0, "PanoramaUI");
}
