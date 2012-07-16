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

QDeclarativeListProperty<Package> PNDFilter::getPackages()
{
  return QDeclarativeListProperty<Package>(this, packages);
}

QList<QObject*> PNDFilter::all()
{
  QList<QObject*> result;
  result.reserve(packages.size());
  foreach(Package* p, packages)
  {
    result << p;
  }
  return result;
}

PNDFilter *PNDFilter::copy()
{
  return new PNDFilter(packages);
}

PNDFilter* PNDFilter::inCategory(QString categoryFilter)
{
  QRegExp re(categoryFilter);
  QList<Package*> result;
  result.reserve(packages.size());
  foreach(Package* p, packages)
  {
    foreach(QPndman::Category const* category, p->getCategories())
    {
      if(re.exactMatch(category->getMain()))
      {
        result << p;
        break;
      }
    }

  }
  result.swap(packages);
  return this;
}

PNDFilter* PNDFilter::installed(bool value)
{
  QList<Package*> result;
  result.reserve(packages.size());
  foreach(Package* p, packages)
  {
    if(p->getInstalled() == value)
    {
      result << p;
    }
  }
  result.swap(packages);
  return this;
}

PNDFilter* PNDFilter::notInstalled()
{
  return installed(false);
}

PNDFilter* PNDFilter::upgradable(bool value)
{
  QList<Package*> result;
  result.reserve(packages.size());
  foreach(Package* p, packages)
  {
    if(p->getHasUpgrade() == value)
    {
      result << p;
    }
  }
  result.swap(packages);
  return this;
}

PNDFilter* PNDFilter::notUpgradable()
{
  return upgradable(false);
}

PNDFilter* PNDFilter::downloading(bool value)
{
  QList<Package*> result;
  result.reserve(packages.size());
  foreach(Package* p, packages)
  {
    if(p->getIsDownloading() == value)
    {
      result << p;
    }
  }
  result.swap(packages);
  return this;
}

PNDFilter* PNDFilter::notDownloading()
{
  return downloading(false);
}

bool titleAlphabeticalSorter(Package const* a, Package const* b) {
  return a->getTitle().toLower() < b->getTitle().toLower();
}

PNDFilter *PNDFilter::sortedByTitle()
{
  qSort(packages.begin(), packages.end(), titleAlphabeticalSorter);
  return this;
}

bool lastUpdatedDateSorter(Package const* a, Package const* b) {
  if(a->getIsForeign() != b->getIsForeign())
  {
    return b->getIsForeign();
  }
  else
  {
    return a->getModified() > b->getModified();
  }
}

PNDFilter *PNDFilter::sortedByLastUpdated()
{
  qSort(packages.begin(), packages.end(), lastUpdatedDateSorter);
  return this;
}

bool ratingSorter(Package const* a, Package const* b) {
  return a->getRating() > b->getRating();
}

PNDFilter *PNDFilter::sortedByRating()
{
  qSort(packages.begin(), packages.end(), ratingSorter);
  return this;
}

PNDFilter *PNDFilter::titleContains(const QString &s)
{
  if(s.isEmpty() || s.isNull())
    return this;

  QList<Package*> result;
  result.reserve(packages.size());
  foreach(Package* p, packages)
  {
    if(p->getTitle().contains(s, Qt::CaseInsensitive))
    {
      result << p;
    }
  }
  result.swap(packages);
  return this;
}

