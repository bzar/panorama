#ifndef PNDMANAGEMENTPLUGIN_H
#define PNDMANAGEMENTPLUGIN_H

#include <qdeclarative.h>
#include <QDeclarativeExtensionPlugin>

class PNDManagementPlugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT
public:
    void registerTypes(const char *uri);
};

#endif
