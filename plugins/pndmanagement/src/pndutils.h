#ifndef PNDUTILS_H
#define PNDUTILS_H

#include <QObject>
#include "package.h"

class PNDUtils : public QObject
{
  Q_OBJECT
public:
  explicit PNDUtils(QObject *parent = 0);
  Q_INVOKABLE QString createCategoryString(Package* package);
  Q_INVOKABLE QString createRatingString(Package* package);
  Q_INVOKABLE QString createOwnRatingString(Package* package);
signals:
  
public slots:
  
};

#endif // PNDUTILS_H
