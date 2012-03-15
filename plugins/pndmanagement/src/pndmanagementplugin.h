#ifndef PNDMANAGEMENTPLUGIN_H
#define PNDMANAGEMENTPLUGIN_H

#include <QtDeclarative>
#include <QDeclarativeExtensionPlugin>
#include "qtpndman.h"

class PNDManagementPlugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT
public:
    void registerTypes(const char *uri);
    void initializeEngine(QDeclarativeEngine *engine, const char *uri);
};

QML_DECLARE_TYPE(QPndman::Version)

#endif
