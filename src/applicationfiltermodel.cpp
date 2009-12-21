#include "applicationfiltermodel.h"

ApplicationFilterModel::ApplicationFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{}

ApplicationFilterModel::ApplicationFilterModel(QAbstractItemModel *sourceModel, QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setSourceModel(sourceModel);
    setRoleNames(sourceModel->roleNames());
}

bool ApplicationFilterModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if(filterRole() == ApplicationModel::Categories)
    {
        const QModelIndex idx = sourceModel()->index(sourceRow, 0, sourceParent);
        QStringList categories = sourceModel()->data(idx, ApplicationModel::Categories).toStringList();

        if(categories.isEmpty())
            categories.append("NoCategory");

        foreach(const QString &category, categories)
            if(filterRegExp().exactMatch(category))
                return true;

        return false;
    }
    else
        return QSortFilterProxyModel::filterAcceptsRow(sourceRow, sourceParent);
}

QVariant ApplicationFilterModel::inCategory(const QString &category)
{
    return ApplicationFilterMethods::inCategory(this, category);
}

QVariant ApplicationFilterModel::matching(const QString &role, const QString &value)
{
    return ApplicationFilterMethods::matching(this, role, value);
}

QVariant ApplicationFilterModel::sortedBy(const QString &role, bool ascending)
{
    return ApplicationFilterMethods::sortedBy(this, role, ascending);
}