#ifndef PNDMAN_PNDLISTMODEL_H
#define PNDMAN_PNDLISTMODEL_H

#include <QAbstractListModel>
#include <QVariant>
#include <QtDeclarative>

class PNDManager;

class PNDListModel : public QAbstractListModel
{
  Q_OBJECT
public:
  enum Role { Id = Qt::UserRole, Path, Icon, Info, Md5, Url, Vendor, Device, Size, Modified, 
              Rating, Author, Version, Title, Titles, Description, Descriptions, Categories, 
              Applications, Installed, BytesDownloaded, BytesToDownload, Upgrade };
  
  PNDListModel(PNDManager* manager = 0, QObject* parent = 0);
  PNDListModel(PNDListModel const& other);
  PNDListModel& operator=(PNDListModel const& other);
  ~PNDListModel();

  virtual QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
  virtual int rowCount(const QModelIndex& parent = QModelIndex()) const;

private slots:
  void crawling();
  void crawlDone();
  void syncing();
  void syncDone();
  
private:
  void setManager(PNDManager* newManager);
  void initializeData();
  
  PNDManager* manager;
};

QML_DECLARE_TYPE(PNDListModel);
#endif
