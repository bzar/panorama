#include "networkmanagerplugin.h"
#include "networkmanagerproxy.h"

void NetworkManagerPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<NetworkManagerProxy>(uri, 1, 0, "NetworkManager");
}

Q_EXPORT_PLUGIN2(networkmanager,NetworkManagerPlugin)
