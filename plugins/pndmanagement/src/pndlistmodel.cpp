#include "pndlistmodel.h"
#include "pndmanager.h"
#include <QDebug>

PNDListModel::PNDListModel(PNDManager* manager, QObject* parent) : QAbstractListModel(parent), manager(0)
{
  qDebug() << "PNDListModel constructor";
  setManager(manager);
  initializeData();
}

PNDListModel::PNDListModel(PNDListModel const& other) : QAbstractListModel(), manager(0)
{
  qDebug() << "PNDListModel copy constructor";
  setManager(other.manager);
  initializeData();
}

PNDListModel& PNDListModel::operator=(PNDListModel const& other)
{
  qDebug() << "PNDListModel assignment operator";
  setManager(other.manager);
  return *this;
}

PNDListModel::~PNDListModel()
{
  qDebug() << "PNDListModel destructor";
}

template<typename T>
QList<QVariant> toQVariantList(QList<T> list)
{
  QList<QVariant> result;
  foreach(T t, list)
  {
    QVariant v;
    v.setValue(t);
    result << v;
  }
  return result;
}

QVariant PNDListModel::data(const QModelIndex& index, int role) const
{
  Package* package = manager->getPackages().at(index.row());
  QVariant var;
  switch(role)
  {
    case Id: var.setValue(package->getId()); break;
    case Path: var.setValue(package->getPath()); break;
    case Icon: var.setValue(package->getIcon()); break;
    case Info: var.setValue(package->getInfo()); break;
    case Md5: var.setValue(package->getMd5()); break;
    case Url: var.setValue(package->getUrl()); break;
    case Vendor: var.setValue(package->getVendor()); break;
    case Device: var.setValue(package->getDevice()); break;
    case Size: var.setValue(package->getSize()); break;
    case Modified: var.setValue(package->getModified()); break;
    case Rating: var.setValue(package->getRating()); break;
    case Author: var.setValue(package->getAuthor()); break;
    case Version: var.setValue(package->getVersion()); break;
    case Title: var.setValue(package->getTitle()); break;
    case Titles: var.setValue(toQVariantList(package->getTitles())); break;
    case Description: var.setValue(package->getDescription()); break;
    case Descriptions: var.setValue(toQVariantList(package->getDescriptions())); break;
    case Categories: var.setValue(toQVariantList(package->getCategories())); break;
    case Applications: var.setValue(toQVariantList(package->getApplications())); break;
    case Installed: var.setValue(package->getInstalled()); break;
    case BytesDownloaded: var.setValue(package->getBytesDownloaded()); break;
    case BytesToDownload: var.setValue(package->getBytesToDownload()); break;
    case Upgrade: var.setValue(!package->getUpgradeCandidate().isNull()); break;
    default: var.setValue(QVariant()); break;
  }
  
  return var;
}

int PNDListModel::rowCount(const QModelIndex& parent) const
{
  return manager->getPackages().size();
}

void PNDListModel::crawling()
{
  beginResetModel();
}

void PNDListModel::syncing()
{
  beginResetModel();
}

void PNDListModel::crawlDone()
{
  endResetModel();
}

void PNDListModel::syncDone()
{
  endResetModel();
}

void PNDListModel::setManager(PNDManager* newManager)
{
  if(manager != newManager)
  {
    if(manager)
    {
      disconnect(manager);
    }
    
    manager = newManager;
    
    if(manager)
    {
      connect(manager, SIGNAL(crawling()), this, SLOT(crawling()));
      connect(manager, SIGNAL(syncing(QPndman::SyncHandle*)), this, SLOT(syncing()));
      connect(manager, SIGNAL(crawlDone()), this, SLOT(crawlDone()));
      connect(manager, SIGNAL(syncDone()), this, SLOT(syncDone()));
    }
  }
}

void PNDListModel::initializeData()
{
  QHash<int, QByteArray> roles;
    roles[Id] = QString("identifier").toLocal8Bit();
    roles[Path] = QString("installPath").toLocal8Bit();
    roles[Icon] = QString("icon").toLocal8Bit();
    roles[Info] = QString("info").toLocal8Bit();
    roles[Md5] = QString("md5").toLocal8Bit();
    roles[Url] = QString("url").toLocal8Bit();
    roles[Vendor] = QString("vendor").toLocal8Bit();
    roles[Device] = QString("device").toLocal8Bit();
    roles[Size] = QString("size").toLocal8Bit();
    roles[Modified] = QString("modified").toLocal8Bit();
    roles[Rating] = QString("rating").toLocal8Bit();
    roles[Author] = QString("author").toLocal8Bit();
    roles[Version] = QString("version").toLocal8Bit();
    roles[Title] = QString("title").toLocal8Bit();
    roles[Titles] = QString("titles").toLocal8Bit();
    roles[Description] = QString("description").toLocal8Bit();
    roles[Descriptions] = QString("descriptions").toLocal8Bit();
    roles[Categories] = QString("categories").toLocal8Bit();
    roles[Applications] = QString("applications").toLocal8Bit();
    roles[Installed] = QString("installed").toLocal8Bit();
    roles[BytesDownloaded] = QString("bytesDownloaded").toLocal8Bit();
    roles[BytesToDownload] = QString("bytesToDownload").toLocal8Bit();
    roles[Upgrade] = QString("upgrade").toLocal8Bit();
    setRoleNames(roles);
}
