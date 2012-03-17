#include "pndfilter.h"
#include <QDebug>

PNDFilter::PNDFilter(QList<Package *> packages, QObject *parent) : QObject(parent), packages(packages)
{
}

PNDFilter::PNDFilter(const PNDFilter &other) : QObject(0), packages(other.packages)
{
}

PNDFilter &PNDFilter::operator=(const PNDFilter &other)
{
  packages = other.packages;
}

QList<QObject*> PNDFilter::all()
{
  QList<QObject*> result;
  foreach(Package* p, packages)
  {
    result << p;
  }
  return result;
}

PNDFilter* PNDFilter::inCategory(QString categoryFilter)
{
  QRegExp re(categoryFilter);
  QList<Package*> result;
  foreach(Package* p, packages)
  {
    for(int i = 0; i < p->categoryCount(); ++i)
    {
      QPndman::Category* category = p->getCategory(i);
      if(re.exactMatch(category->getMain()))
      {
        result << p;
        break;
      }
    }

  }
  return new PNDFilter(result);
}

PNDFilter* PNDFilter::installed(bool value)
{
  QList<Package*> result;
  foreach(Package* p, packages)
  {
    if(p->getInstalled() == value)
    {
      result << p;
    }
  }
  return new PNDFilter(result);
}

PNDFilter* PNDFilter::notInstalled()
{
  return installed(false);
}

PNDFilter* PNDFilter::upgradable(bool value)
{
  QList<Package*> result;
  foreach(Package* p, packages)
  {
    if(p->getHasUpgrade() == value)
    {
      result << p;
    }
  }
  return new PNDFilter(result);
}

PNDFilter* PNDFilter::notUpgradable()
{
  return upgradable(false);
}

PNDFilter* PNDFilter::downloading(bool value)
{
  QList<Package*> result;
  foreach(Package* p, packages)
  {
    if(p->getIsDownloading() == value)
    {
      result << p;
    }
  }
  return new PNDFilter(result);
}

PNDFilter* PNDFilter::notDownloading()
{
  return downloading(false);
}

