#ifndef APPLICATIONSPLUGIN_H
#define APPLICATIONSPLUGIN_H

#include <QQmlExtensionPlugin>

class ApplicationsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // APPLICATIONSPLUGIN_H
