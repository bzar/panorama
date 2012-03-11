#include "package.h"
#include "pndmanager.h"

Package::Package(PNDManager* manager, QPndman::Package const& p, bool installed, QObject* parent):
  QPndman::Package(p), manager(manager), installed(installed), bytesDownloaded(installed ? 1 : 0), bytesToDownload(1)
{
  setParent(parent);
  connect(this, SIGNAL(upgradeCandidateChanged(Package*)), this, SIGNAL(hasUpgradeChanged()));
}

Package::Package(QObject* parent) : QPndman::Package(parent), installed(false), bytesDownloaded(0), bytesToDownload(0)
{
  connect(this, SIGNAL(upgradeCandidateChanged(Package*)), this, SIGNAL(hasUpgradeChanged()));
}

Package::Package(const Package& other) : QPndman::Package(other), installed(other.installed), bytesDownloaded(other.bytesDownloaded), bytesToDownload(other.bytesToDownload)
{
  connect(this, SIGNAL(upgradeCandidateChanged(Package*)), this, SIGNAL(hasUpgradeChanged()));
}

Package& Package::operator=(const Package& other)
{
  QPndman::Package::operator=(other);
  setInstalled(other.installed);
  setBytesDownloaded(other.bytesDownloaded);
  setBytesToDownload(other.bytesToDownload);
}

bool Package::getInstalled() const
{
  return installed;
}

qint64 Package::getBytesDownloaded() const
{
  return bytesDownloaded;
}

qint64 Package::getBytesToDownload() const
{
  return bytesToDownload;
}

bool Package::getHasUpgrade() const
{
  return !getUpgradeCandidate()->isNull();
}

bool Package::getIsDownloading() const
{
  return bytesDownloaded > 0 && bytesDownloaded != bytesToDownload;
}

void Package::setInstalled()
{
  setBytesDownloaded(bytesToDownload);
  setInstalled(true);
}

void Package::setInstalled(bool value)
{
  if(installed != value)
  {
    installed = value;
    emit installedChanged(installed);
  }
}

void Package::setBytesDownloaded(qint64 value)
{
  if(bytesDownloaded != value)
  {
    bytesDownloaded = value;
    emit bytesDownloadedChanged(bytesDownloaded);
  }
}

void Package::setBytesToDownload(qint64 value)
{
  if(bytesToDownload != value)
  {
    bytesToDownload = value;
    emit bytesToDownloadChanged(bytesDownloaded);
  }
}

void Package::install(QObject *device, QString location)
{
  QPndman::Enum::InstallLocation installLocation = QPndman::Enum::DesktopAndMenu;
  if(location == "Desktop") {
    installLocation = QPndman::Enum::Desktop;
  } else if(location == "Menu") {
    installLocation = QPndman::Enum::Menu;
  }
  QPndman::Device* dev = qobject_cast<QPndman::Device*>(device);
  manager->install(this, dev, installLocation);
}

void Package::remove()
{
  manager->remove(this);
}

void Package::upgrade()
{
 manager->upgrade(this);
}

void Package::updateFrom(QPndman::Package package)
{
  setPndmanPackage(package.getPndmanPackage());
  setPath(package.getPath());
  setId(package.getId());
  setIcon(package.getIcon());
  setInfo(package.getInfo());
  setMd5(package.getMd5());
  setUrl(package.getUrl());
  setVendor(package.getVendor());
  setDevice(package.getDevice());
  setSize(package.getSize());
  setModified(package.getModified());
  setRating(package.getRating());
  setAuthor(package.getAuthor());
  setVersion(package.getVersion());
  setApplications(package.getApplications());
  setTitles(package.getTitles());
  setDescriptions(package.getDescriptions());
  setCategories(package.getCategories());
  setUpgradeCandidate(package.getUpgradeCandidate());
}

QPndman::UpgradeHandle* Package::upgradePackage(bool force)
{
  return QPndman::Package::upgrade(force);
}
