#ifndef PANDORAPLUGIN_H
#define PANDORAPLUGIN_H

#include <QQmlExtensionPlugin>

class PandoraPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
public:
    void registerTypes(const char *uri);
};

#endif // PANDORAPLUGIN_H
