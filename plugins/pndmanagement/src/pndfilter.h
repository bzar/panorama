#ifndef PNDFILTER_H
#define PNDFILTER_H

#include <QObject>
#include <QtDeclarative>
#include "package.h"

class PNDFilter : public QObject
{
  Q_OBJECT
public:
  PNDFilter(QList<Package*> packages = QList<Package*>(), QObject *parent = 0);
  PNDFilter(PNDFilter const& other);
  PNDFilter& operator=(PNDFilter const& other);

  Q_INVOKABLE QList<QObject*> all();
  Q_INVOKABLE PNDFilter* inCategory(QString categoryFilter);
  Q_INVOKABLE PNDFilter* installed(bool value = true);
  Q_INVOKABLE PNDFilter* notInstalled();
  Q_INVOKABLE PNDFilter* upgradable(bool value = true);
  Q_INVOKABLE PNDFilter* notUpgradable();
  Q_INVOKABLE PNDFilter* downloading(bool value = true);
  Q_INVOKABLE PNDFilter* notDownloading();
private:
  QList<Package*> packages;
};

QML_DECLARE_TYPE(PNDFilter)
#endif // PNDFILTER_H
