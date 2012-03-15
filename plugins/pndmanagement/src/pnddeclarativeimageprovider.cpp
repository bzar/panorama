#include "pnddeclarativeimageprovider.h"
#include "pnd_apps.h"
#include "pnd_pndfiles.h"

#include <QDir>
#include <QEventLoop>
#include <QCryptographicHash>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QDebug>
#include <QUrl>
#include <QtConcurrentRun>

namespace
{
  QByteArray download(QString url)
  {
    QEventLoop eventLoop;
    QNetworkAccessManager manager(&eventLoop);
    QNetworkReply* reply = manager.get(QNetworkRequest(QUrl(url)));
    QObject::connect(reply, SIGNAL(finished()), &eventLoop, SLOT(quit()));
    QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), &eventLoop, SLOT(quit()));
    eventLoop.exec();
    return reply->readAll();
  }
}

PNDDeclarativeImageProvider::PNDDeclarativeImageProvider() :
  QDeclarativeImageProvider(QDeclarativeImageProvider::Image)
{
}

QImage PNDDeclarativeImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
  qDebug() << "PNDDeclarativeImageProvider::requestImage" << id;
  QImage image;
  if(id.startsWith("http://")) {
    QFuture<QByteArray> data = QtConcurrent::run(download, id);
    image.loadFromData(data.result());
  }
  else if(QFile(PND_PNDRUN_DEFAULT).exists())
  {
    QStringList idParts = id.split("::");
    QString pndPath = idParts.at(0);
    QString imagePath = idParts.at(1);
    QCryptographicHash hasher(QCryptographicHash::Md5);
    hasher.addData(id.toLocal8Bit());
    QString hash = hasher.result().toHex();
    if(pnd_pnd_mount(PND_PNDRUN_DEFAULT, pndPath.toLocal8Bit().data(), hash.toLocal8Bit().data()) <= 0)
    {
      qDebug() << "ERROR: Could not mount PND" << hash;
      return image;
    }

    QString filePath = QString("/mnt/utmp/%1/%2").arg(hash).arg(imagePath);
    image.load(filePath);
    pnd_pnd_unmount(PND_PNDRUN_DEFAULT, pndPath.toLocal8Bit().data(), hash.toLocal8Bit().data());
  }

  size->setWidth(image.width());
  size->setHeight(image.height());

  if(requestedSize.isNull() || requestedSize.isEmpty() || !requestedSize.isValid())
  {
    return image;
  }

  return image.scaled(requestedSize);
}
