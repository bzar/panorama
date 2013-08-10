#include "pnddeclarativeimageprovider.h"
#include "pnd_apps.h"
#include "pnd_pndfiles.h"

#include <QDebug>

QList< QPointer<PNDManager> > PNDDeclarativeImageProvider::managers;

PNDDeclarativeImageProvider::PNDDeclarativeImageProvider() :
  QDeclarativeImageProvider(QDeclarativeImageProvider::Image)
{
}

QImage PNDDeclarativeImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
  QImage image;
  qDebug() << "Searching for icon for pnd " << id;
  foreach(QPointer<PNDManager> p, managers)
  {
    if(p.isNull())
    {
      continue;
    }

    Package* package = p->getPackageById(id);

    if(package)
    {
      qDebug() << "   Found it!";
      image = package->getEmbeddedIcon();

      if(!image.isNull())
      {
        if(requestedSize.width() && requestedSize.height())
        {
          image = image.scaled(requestedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);
        }
        else if(requestedSize.width())
        {
          image = image.scaledToWidth(requestedSize.width(), Qt::SmoothTransformation);
        }
        else if(requestedSize.height())
        {
          image = image.scaledToHeight(requestedSize.height(), Qt::SmoothTransformation);
        }

        break;
      }
    }
  }

  if(image.isNull())
  {
    qDebug() << "   Not found!";
  }
  return image;
}

void PNDDeclarativeImageProvider::registerPNDManager(PNDManager *pndManager)
{
  managers.append(QPointer<PNDManager>(pndManager));
}
