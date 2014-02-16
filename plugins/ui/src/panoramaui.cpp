#include "panoramaui.h"

class PanoramaUIPrivate
{
    PANORAMA_DECLARE_PUBLIC(PanoramaUI)
public:
    QString name;
    QString description;
    QString author;
};

PanoramaUI::PanoramaUI(QQuickItem *parent) :
    QQuickItem(parent)
{
    PANORAMA_INITIALIZE(PanoramaUI);
    setWidth(PANORAMA_UI_WIDTH);
    setHeight(PANORAMA_UI_HEIGHT);
    setX(0);
    setY(0);
    setClip(true);
}

PanoramaUI::~PanoramaUI()
{
    PANORAMA_UNINITIALIZE(PanoramaUI);
}

void PanoramaUI::setName(const QString &value)
{
    PANORAMA_PRIVATE(PanoramaUI);
    priv->name = value;
}

QString PanoramaUI::name() const
{
    PANORAMA_PRIVATE(const PanoramaUI);
    return priv->name;
}

void PanoramaUI::setDescription(const QString &value)
{
    PANORAMA_PRIVATE(PanoramaUI);
    priv->description = value;
}

QString PanoramaUI::description() const
{
    PANORAMA_PRIVATE(const PanoramaUI);
    return priv->description;
}

void PanoramaUI::setAuthor(const QString &value)
{
    PANORAMA_PRIVATE(PanoramaUI);
    priv->author = value;
}

QString PanoramaUI::author() const
{
    PANORAMA_PRIVATE(const PanoramaUI);
    return priv->author;
}
