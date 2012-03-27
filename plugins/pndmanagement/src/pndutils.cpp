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
