#ifndef PNDDECLARATIVEIMAGEPROVIDER_H
#define PNDDECLARATIVEIMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QList>
#include <QPointer>
#include "pndmanager.h"

class PNDDeclarativeImageProvider : public QQuickImageProvider
{
public:
  explicit PNDDeclarativeImageProvider();
  QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);

  static void registerPNDManager(PNDManager* pndManager);
signals:
  
public slots:

private:
  static QList< QPointer<PNDManager> > managers;
  
};

#endif // PNDDECLARATIVEIMAGEPROVIDER_H
