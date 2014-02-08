#ifndef NETWORKMANAGERPROXY_H
#define NETWORKMANAGERPROXY_H

#include "panoramainternal.h"

#include <QObject>
#include <QString>
#include <QDebug>
#include <qdeclarative.h>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <NetworkManagerQt/Manager>
#include <NetworkManagerQt/Device>
#include <NetworkManagerQt/Connection>

class NetworkManagerPrivate;

class NetworkManagerProxy : public QObject
{
  Q_OBJECT
  typedef NetworkManager::Status Status;
  Q_ENUMS(Status)
  Q_PROPERTY(Status status READ status NOTIFY statusChanged)
  Q_PROPERTY(QDeclarativeListProperty<NetworkManager::Device> networkInterfaces READ networkInterfaces NOTIFY devicesChanged)
  Q_PROPERTY(QDeclarativeListProperty<NetworkManager::ActiveConnection> activeConnections READ activeConnections NOTIFY activeConnectionsChanged)
  Q_PROPERTY(QStringList activeConnectionsPaths READ activeConnectionsPaths NOTIFY activeConnectionsChanged)

  Q_PROPERTY(bool networkingEnabled READ isNetworkingEnabled WRITE setNetworkingEnabled NOTIFY networkingEnabledChanged)
  Q_PROPERTY(bool wirelessEnabled READ isWirelessEnabled WRITE setWirelessEnabled NOTIFY wirelessEnabledChanged)
  Q_PROPERTY(bool wwanEnabled READ isWwanEnabled WRITE setWwanEnabled NOTIFY wwanEnabledChanged)
  Q_PROPERTY(bool wimaxEnabled READ isWimaxEnabled WRITE setWimaxEnabled NOTIFY wimaxEnabledChanged)
  Q_PROPERTY(bool wirelessHardwareEnabled READ isWirelessHardwareEnabled NOTIFY wirelessHardwareEnabledChanged)
  Q_PROPERTY(bool wwanHardwareEnabled READ isWwanHardwareEnabled NOTIFY wwanHardwareEnabledChanged)
  Q_PROPERTY(bool wimaxHardwareEnabled READ isWimaxHardwareEnabled NOTIFY wimaxHardwareEnabledChanged)

public:
  explicit NetworkManagerProxy(QObject *parent = 0);
  ~NetworkManagerProxy();

  NetworkManager::Status status();
  QDeclarativeListProperty<NetworkManager::Device> networkInterfaces();
  QDeclarativeListProperty<NetworkManager::ActiveConnection> activeConnections();
  QStringList activeConnectionsPaths();

  bool isNetworkingEnabled();
  bool isWirelessEnabled();
  bool isWwanEnabled();
  bool isWimaxEnabled();
  bool isWirelessHardwareEnabled();
  bool isWwanHardwareEnabled();
  bool isWimaxHardwareEnabled();
  void setNetworkingEnabled(bool enabled);
  void setWirelessEnabled(bool enabled);
  void setWwanEnabled(bool enabled);
  void setWimaxEnabled(bool enabled);

  Q_INVOKABLE NetworkManager::Device::Ptr findNetworkInterface(const QString &uni);
  Q_INVOKABLE NetworkManager::Device::Ptr findDeviceByIpFace(const QString &iface);
  Q_INVOKABLE NetworkManager::ActiveConnection::Ptr findActiveConnection(const QString &uni);

public slots:
  QDBusPendingReply<QDBusObjectPath> activateConnection(const QString &connectionUni, const QString &interfaceUni, const QString &connectionParameter);
  QDBusPendingReply<QDBusObjectPath, QDBusObjectPath> addAndActivateConnection(const NMVariantMapMap &connection, const QString &interfaceUni, const QString &connectionParameter);
  void deactivateConnection(const QString &activeConnection);
  NetworkManager::Device::Types supportedInterfaceTypes();


signals:
  void statusChanged(NetworkManager::Status status);
  void deviceAdded(const QString &uni);
  void deviceRemoved(const QString &uni);
  void devicesChanged();
  void wirelessEnabledChanged(bool);
  void wwanEnabledChanged(bool);
  void wimaxEnabledChanged(bool);
  void wirelessHardwareEnabledChanged(bool);
  void wwanHardwareEnabledChanged(bool);
  void wimaxHardwareEnabledChanged(bool);
  void networkingEnabledChanged(bool);
  void activeConnectionAdded(const QString &path);
  void activeConnectionRemoved(const QString &path);
  void activeConnectionsChanged();
  void serviceDisappeared();
  void serviceAppeared();
};

#endif // NETWORKMANAGERPROXY_H
