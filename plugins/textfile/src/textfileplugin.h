#ifndef TEXTFILEPLUGIN_H
#define TEXTFILEPLUGIN_H

#include <QQmlExtensionPlugin>

class TextFilePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
public:
    void registerTypes(const char *uri);
};

#endif // TEXTFILEPLUGIN_H
