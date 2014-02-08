#ifndef NETWORKMANAGERPLUGIN_H
#define NETWORKMANAGERPLUGIN_H

#include <qdeclarative.h>
#include <QDeclarativeExtensionPlugin>

class NetworkManagerPlugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT
public:
    void registerTypes(const char *uri);
};

#endif // NETWORKMANAGERPLUGIN_H
