#include "milkypackage.h"

MilkyPackage::MilkyPackage(QObject *parent) :
    QObject(parent)
{
}

MilkyPackage::MilkyPackage(MilkyPackage const& other) :
    QObject()
{
    id = other.id;
    title = other.title;
    description = other.description;
    info = other.info;
    icon = other.icon;
    uri = other.uri;
    md5 = other.md5;
    vendor = other.vendor;
    group = other.group;
    modified = other.modified;
    rating = other.rating;
    size = other.size;
    author = other.author;
    installedVersion = other.installedVersion;
    currentVersion = other.currentVersion;
    installed = other.installed;
    hasUpdate = other.hasUpdate;
    foreign = other.foreign;
    installPath = other.installPath;
    deviceMount = other.deviceMount;
    device = other.device;
    categories = other.categories;
    previewPics = other.previewPics;
    licenses = other.licenses;
    sourceLinks = other.sourceLinks;
}

MilkyPackage const& MilkyPackage::operator=(MilkyPackage const& other)
{
    if(&other != this)
    {
        id = other.id;
        title = other.title;
        description = other.description;
        info = other.info;
        icon = other.icon;
        uri = other.uri;
        md5 = other.md5;
        vendor = other.vendor;
        group = other.group;
        modified = other.modified;
        rating = other.rating;
        size = other.size;
        author = other.author;
        installedVersion = other.installedVersion;
        currentVersion = other.currentVersion;
        installed = other.installed;
        hasUpdate = other.hasUpdate;
        foreign = other.foreign;
        installPath = other.installPath;
        deviceMount = other.deviceMount;
        device = other.device;
        categories = other.categories;
        previewPics = other.previewPics;
        licenses = other.licenses;
        sourceLinks = other.sourceLinks;
    }

    return *this;
}

MilkyPackage::MilkyPackage(pnd_package* p, QObject* parent) :
    QObject(parent)
{
    setId(p->id);
    setTitle(p->title);
    setDescription(p->desc);
    setInfo(p->info);
    setIcon(p->icon);
    setUri(p->uri);
    setMD5(p->md5);
    setVendor(p->vendor);
    setGroup(p->group);
    setModified(QDateTime::fromMSecsSinceEpoch(static_cast<qint64>(p->modified_time) * 1000));
    setRating(p->rating);
    setSize(p->size);
    setAuthorName(p->author->name);
    setAuthorSite(p->author->website);
    setAuthorEmail(p->author->email);
    setInstalledVersionMajor(p->local_version->major);
    setInstalledVersionMinor(p->local_version->minor);
    setInstalledVersionRelease(p->local_version->release);
    setInstalledVersionBuild(p->local_version->build);
    setInstalledVersionType(p->local_version->type);
    setCurrentVersionMajor(p->version->major);
    setCurrentVersionMinor(p->version->minor);
    setCurrentVersionRelease(p->version->release);
    setCurrentVersionBuild(p->version->build);
    setCurrentVersionType(p->version->type);
    setInstalled(p->installed);
    setHasUpdate(p->hasupdate);
    setForeign(p->foreign);
    setInstallPath(p->install_path);
    setDeviceMount(p->mount);
    setDevice(p->device);
    setCategories(alpmListToQStringList(p->categories));
    setPreviewPics(alpmListToQStringList(p->previewpics));
    setLicenses(alpmListToQStringList(p->licenses));
    setSourceLinks(alpmListToQStringList(p->source));
}

QString MilkyPackage::getId() const
{
    return id;
}
QString MilkyPackage::getTitle() const
{
    return title;
}
QString MilkyPackage::getDescription() const
{
    return description;
}
QString MilkyPackage::getInfo() const
{
    return info;
}
QString MilkyPackage::getIcon() const
{
    return icon;
}
QString MilkyPackage::getUri() const
{
    return uri;
}
QString MilkyPackage::getMD5() const
{
    return md5;
}
QString MilkyPackage::getVendor() const
{
    return vendor;
}
QString MilkyPackage::getGroup() const
{
    return group;
}
QDateTime MilkyPackage::getModified() const
{
    return modified;
}

QString MilkyPackage::getLastUpdatedString() const
{
    if(modified.toMSecsSinceEpoch() == 0) {
        return "unknown";
    }

    qint64 now = QDateTime::currentMSecsSinceEpoch();
    qint64 days = (now - modified.toMSecsSinceEpoch()) / (1000 * 60*60*24);

    if(days == 0)
    {
        return "today";
    }
    else if(days == 1)
    {
        return "yesterday";
    }
    else if(days < 2*7)
    {
        return QString("%1 %2").arg(days).arg("days ago");
    }
    else if(days < 2*30)
    {
        return QString("%1 %2").arg(days/7).arg("weeks ago");
    }
    else if(days < 2*365)
    {
        return QString("%1 %2").arg(days/30).arg("months ago");
    }
    else
    {
        return QString("%1 %2").arg(days/365).arg("years ago");
    }
}

int MilkyPackage::getRating() const
{
    return rating;
}
int MilkyPackage::getSize() const
{
    return size;
}
QString MilkyPackage::getSizeString() const
{
    quint64 s = size;
    QString suffix = "B";
    quint64 kilo = 1024;
    if(s > kilo*kilo*kilo*kilo)
    {
        suffix = "TiB";
        s /= kilo*kilo*kilo*kilo;
    }
    else if(s > kilo*kilo*kilo)
    {
        suffix = "GiB";
        s /= kilo*kilo*kilo;
    }
    if(s > kilo*kilo)
    {
        suffix = "MiB";
        s /= kilo*kilo;
    }
    if(s > kilo)
    {
        suffix = "KiB";
        s /= kilo;
    }
    return QString("%1 %2").arg(s).arg(suffix);
}
QString MilkyPackage::getAuthorName() const
{
    return author.name;
}
QString MilkyPackage::getAuthorSite() const
{
    return author.site;
}
QString MilkyPackage::getAuthorEmail() const
{
    return author.email;
}

QString MilkyPackage::getInstalledVersionMajor() const
{
    return installedVersion.major;
}
QString MilkyPackage::getInstalledVersionMinor() const
{
    return installedVersion.minor;
}
QString MilkyPackage::getInstalledVersionRelease() const
{
    return installedVersion.release;
}
QString MilkyPackage::getInstalledVersionBuild() const
{
    return installedVersion.build;
}
QString MilkyPackage::getInstalledVersionType() const
{
    return installedVersion.type;
}

QString MilkyPackage::getCurrentVersionMajor() const
{
    return currentVersion.major;
}
QString MilkyPackage::getCurrentVersionMinor() const
{
    return currentVersion.minor;
}
QString MilkyPackage::getCurrentVersionRelease() const
{
    return currentVersion.release;
}
QString MilkyPackage::getCurrentVersionBuild() const
{
    return currentVersion.build;
}
QString MilkyPackage::getCurrentVersionType() const
{
    return currentVersion.type;
}

bool MilkyPackage::getInstalled() const
{
    return installed;
}
bool MilkyPackage::getHasUpdate() const
{
    return hasUpdate;
}
bool MilkyPackage::getForeign() const
{
    return foreign;
}

QString MilkyPackage::getInstallPath() const
{
    return installPath;
}
QString MilkyPackage::getDeviceMount() const
{
    return deviceMount;
}
QString MilkyPackage::getDevice() const
{
    return device;
}

QStringList MilkyPackage::getCategories() const
{
    return categories;
}

QString MilkyPackage::getCategoriesString() const
{
    return categories.join(";");
}

QStringList MilkyPackage::getPreviewPics() const
{
    return previewPics;
}

QStringList MilkyPackage::getLicenses() const
{
    return licenses;
}

QStringList MilkyPackage::getSourceLinks() const
{
    return sourceLinks;
}

void MilkyPackage::setId(QString newId)
{
    id = newId;
    emit idChanged(id);
}
void MilkyPackage::setTitle(QString newTitle)
{
    title = newTitle;
    emit titleChanged(title);
}
void MilkyPackage::setDescription(QString newDescription)
{
    description = newDescription;
    emit descriptionChanged(description);
}
void MilkyPackage::setInfo(QString newInfo)
{
    info = newInfo;
    emit infoChanged(info);
}
void MilkyPackage::setIcon(QString newIcon)
{
    icon = newIcon;
    emit iconChanged(icon);
}
void MilkyPackage::setUri(QString newUri)
{
    uri = newUri;
    emit uriChanged(uri);
}
void MilkyPackage::setMD5(QString newMD5)
{
    md5 = newMD5;
    emit md5Changed(md5);
}
void MilkyPackage::setVendor(QString newVendor)
{
    vendor = newVendor;
    emit vendorChanged(vendor);
}
void MilkyPackage::setGroup(QString newGroup)
{
    group = newGroup;
    emit groupChanged(group);
}
void MilkyPackage::setModified(QDateTime newModified)
{
    modified = newModified;
    emit modifiedChanged(modified);
}

void MilkyPackage::setRating(int newRating)
{
    rating = newRating;
    emit ratingChanged(rating);
}
void MilkyPackage::setSize(int newSize)
{
    size = newSize;
    emit sizeChanged(size);
}

void MilkyPackage::setAuthorName(QString newAuthorName)
{
    author.name = newAuthorName;
    emit authorNameChanged(author.name);
}
void MilkyPackage::setAuthorSite(QString newAuthorSite)
{
    author.site = newAuthorSite;
    emit authorSiteChanged(author.site);
}
void MilkyPackage::setAuthorEmail(QString newAuthorEmail)
{
    author.email = newAuthorEmail;
    emit authorEmailChanged(author.email);
}

void MilkyPackage::setInstalledVersionMajor(QString newInstalledVersionMajor)
{
    installedVersion.major = newInstalledVersionMajor;
    emit installedVersionMajorChanged(installedVersion.major);
}
void MilkyPackage::setInstalledVersionMinor(QString newInstalledVersionMinor)
{
    installedVersion.minor = newInstalledVersionMinor;
    emit installedVersionMinorChanged(installedVersion.minor);
}
void MilkyPackage::setInstalledVersionRelease(QString newInstalledVersionRelease)
{
    installedVersion.release = newInstalledVersionRelease;
    emit installedVersionReleaseChanged(installedVersion.release);
}
void MilkyPackage::setInstalledVersionBuild(QString newInstalledVersionBuild)
{
    installedVersion.build = newInstalledVersionBuild;
    emit installedVersionBuildChanged(installedVersion.build);
}
void MilkyPackage::setInstalledVersionType(QString newInstalledVersionType)
{
    installedVersion.type = newInstalledVersionType;
    emit installedVersionTypeChanged(installedVersion.type);
}

void MilkyPackage::setCurrentVersionMajor(QString newCurrentVersionMajor)
{
    currentVersion.major = newCurrentVersionMajor;
    emit currentVersionMajorChanged(currentVersion.major);
}
void MilkyPackage::setCurrentVersionMinor(QString newCurrentVersionMinor)
{
    currentVersion.minor = newCurrentVersionMinor;
    emit currentVersionMinorChanged(currentVersion.minor);
}
void MilkyPackage::setCurrentVersionRelease(QString newCurrentVersionRelease)
{
    currentVersion.release = newCurrentVersionRelease;
    emit currentVersionReleaseChanged(currentVersion.release);
}
void MilkyPackage::setCurrentVersionBuild(QString newCurrentVersionBuild)
{
    currentVersion.build = newCurrentVersionBuild;
    emit currentVersionBuildChanged(currentVersion.build);
}
void MilkyPackage::setCurrentVersionType(QString newCurrentVersionType)
{
    currentVersion.type = newCurrentVersionType;
    emit currentVersionTypeChanged(currentVersion.type);
}

void MilkyPackage::setInstalled(bool newInstalled)
{
    installed = newInstalled;
    emit installedChanged(installed);
}
void MilkyPackage::setHasUpdate(bool newHasUpdate)
{
    hasUpdate = newHasUpdate;
    emit hasUpdateChanged(hasUpdate);
}
void MilkyPackage::setForeign(bool newForeign)
{
    foreign = newForeign;
    emit foreignChanged(foreign);
}
void MilkyPackage::setInstallPath(QString newInstallPath)
{
    installPath = newInstallPath;
    emit installPathChanged(installPath);
}
void MilkyPackage::setDeviceMount(QString newDeviceMount)
{
    deviceMount = newDeviceMount;
    emit deviceMountChanged(deviceMount);
}
void MilkyPackage::setDevice(QString newDevice)
{
    device = newDevice;
    emit deviceChanged(device);
}

void MilkyPackage::setCategories(QStringList newCategories)
{
    categories = newCategories;
    emit categoriesChanged(categories);
    emit categoriesStringChanged(getCategoriesString());
}

void MilkyPackage::setCategoriesString(QString newCategoriesString)
{
    categories = newCategoriesString.split(";");
    emit categoriesChanged(categories);
    emit categoriesStringChanged(getCategoriesString());
}

void MilkyPackage::setPreviewPics(QStringList newPreviewPics)
{
    previewPics = newPreviewPics;
    emit previewPicsChanged(previewPics);
}

void MilkyPackage::setLicenses(QStringList newLicenses)
{
    licenses = newLicenses;
    emit licensesChanged(licenses);
}

void MilkyPackage::setSourceLinks(QStringList newSourceLinks)
{
    sourceLinks = newSourceLinks;
    emit sourceLinksChanged(sourceLinks);
}

QStringList MilkyPackage::alpmListToQStringList(alpm_list_t* node)
{
    QStringList list;
    if(node)
    {
        do
        {
            char* item = static_cast<char*>(node->data);
            list << item;
        } while((node = node->next));
    }

    return list;
}