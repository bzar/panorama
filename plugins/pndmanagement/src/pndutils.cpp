#include "pndutils.h"

PNDUtils::PNDUtils(QObject *parent) :
  QObject(parent)
{
}

QString PNDUtils::createCategoryString(Package *package)
{
  QStringList categories;
  foreach(QPndman::Category* category, package->getCategories())
  {
    QString main = category->getMain();
    QString sub = category->getSub();
    if(!categories.contains(main)) {
      categories << main;
    }
    if(!categories.contains(sub)) {
      categories << sub;
    }
  }

  return categories.join(", ");
}

QString PNDUtils::createRatingString(Package *package)
{
  if(package && package->getRating())
    return QString((package->getRating() + 10)/20, QChar(0x2605));
  else
    return "(not rated)";
}

QString PNDUtils::createOwnRatingString(Package *package)
{
  if(package && package->getOwnRating())
    return QString(package->getOwnRating(), QChar(0x2605));
  else
    return "(not rated)";
}
