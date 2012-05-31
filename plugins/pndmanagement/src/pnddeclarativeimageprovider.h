#ifndef PNDDECLARATIVEIMAGEPROVIDER_H
#define PNDDECLARATIVEIMAGEPROVIDER_H

#include <QDeclarativeImageProvider>

class PNDDeclarativeImageProvider : public QDeclarativeImageProvider
{
public:
  explicit PNDDeclarativeImageProvider();
  QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
signals:
  
public slots:
  
};

#endif // PNDDECLARATIVEIMAGEPROVIDER_H
