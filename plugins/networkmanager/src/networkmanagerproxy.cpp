#include "networkmanagerproxy.h"

namespace
{
  void activeConnectionAppendFunc(QQmlListProperty<NetworkManager::ActiveConnection>* property, NetworkManager::ActiveConnection* value)
  {

  }
  NetworkManager::ActiveConnection* activeConnectionAtFunc(QQmlListProperty<NetworkManager::ActiveConnection>* property, int index)
  {
    return NetworkManager::activeConnections().at(index).data();
  }
  void activeConnectionClearFunc(QQmlListProperty<NetworkManager::ActiveConnection>* property)
  {

  }
  int activeConnectionCountFunc(QQmlListProperty<NetworkManager::ActiveConnection>* property)
  {
    return NetworkManager::activeConnections().size();
  }

  void deviceAppendFunc(QQmlListProperty<NetworkManager::Device>* property, NetworkManager::Device* value)
  {

  }
  NetworkManager::Device* deviceAtFunc(QQmlListProperty<NetworkManager::Device>* property, int index)
  {
    return NetworkManager::networkInterfaces().at(index).data();
  }
  void deviceClearFunc(QQmlListProperty<NetworkManager::Device>* property)
  {

  }
  int deviceCountFunc(QQmlListProperty<NetworkManager::Device>* property)
  {
    return NetworkManager::networkInterfaces().size();
  }

}
NetworkManagerProxy::NetworkManagerProxy(QObject*parent)
  : QObject(parent)
{
  connect(NetworkManager::notifier(), SIGNAL(statusChanged(NetworkManager::Status)), this, SIGNAL(statusChanged(NetworkManager::Status)));
  connect(NetworkManager::notifier(), SIGNAL(deviceAdded(QString)), this, SIGNAL(deviceAdded(QString)));
  connect(NetworkManager::notifier(), SIGNAL(deviceRemoved(QString)), this, SIGNAL(deviceRemoved(QString)));
  connect(NetworkManager::notifier(), SIGNAL(deviceAdded(QString)), this, SIGNAL(devicesChanged()));
  connect(NetworkManager::notifier(), SIGNAL(deviceRemoved(QString)), this, SIGNAL(devicesChanged()));
  connect(NetworkManager::notifier(), SIGNAL(wirelessEnabledChanged(bool)), this, SIGNAL(wirelessEnabledChanged(bool)));
  connect(NetworkManager::notifier(), SIGNAL(wwanEnabledChanged(bool)), this, SIGNAL(wwanEnabledChanged(bool)));
  connect(NetworkManager::notifier(), SIGNAL(wimaxEnabledChanged(bool)), this, SIGNAL(wimaxEnabledChanged(bool)));
  connect(NetworkManager::notifier(), SIGNAL(wirelessHardwareEnabledChanged(bool)), this, SIGNAL(wirelessHardwareEnabledChanged(bool)));
  connect(NetworkManager::notifier(), SIGNAL(wwanHardwareEnabledChanged(bool)), this, SIGNAL(wwanHardwareEnabledChanged(bool)));
  connect(NetworkManager::notifier(), SIGNAL(wimaxHardwareEnabledChanged(bool)), this, SIGNAL(wimaxHardwareEnabledChanged(bool)));
  connect(NetworkManager::notifier(), SIGNAL(networkingEnabledChanged(bool)), this, SIGNAL(networkingEnabledChanged(bool)));
  connect(NetworkManager::notifier(), SIGNAL(activeConnectionAdded(QString)), this, SIGNAL(activeConnectionAdded(QString)));
  connect(NetworkManager::notifier(), SIGNAL(activeConnectionRemoved(QString)), this, SIGNAL(activeConnectionRemoved(QString)));
  connect(NetworkManager::notifier(), SIGNAL(activeConnectionsChanged()), this, SIGNAL(activeConnectionsChanged()));
  connect(NetworkManager::notifier(), SIGNAL(serviceDisappeared()), this, SIGNAL(serviceDisappeared()));
  connect(NetworkManager::notifier(), SIGNAL(serviceAppeared()), this, SIGNAL(serviceAppeared()));
}

NetworkManagerProxy::~NetworkManagerProxy()
{
}

NetworkManager::Status NetworkManagerProxy::status()
{
  return NetworkManager::status();
}

QQmlListProperty<NetworkManager::Device> NetworkManagerProxy::networkInterfaces()
{
  return QQmlListProperty<NetworkManager::Device>(this, 0,
                                                          deviceAppendFunc,
                                                          deviceCountFunc,
                                                          deviceAtFunc,
                                                          deviceClearFunc);
}

NetworkManager::Device::Ptr NetworkManagerProxy::findNetworkInterface(const QString& uni)
{
  return NetworkManager::findNetworkInterface(uni);
}

NetworkManager::Device::Ptr NetworkManagerProxy::findDeviceByIpFace(const QString& iface)
{
  return NetworkManager::findDeviceByIpFace(iface);
}

bool NetworkManagerProxy::isNetworkingEnabled()
{
  return NetworkManager::isNetworkingEnabled();
}

bool NetworkManagerProxy::isWirelessEnabled()
{
  return NetworkManager::isWirelessEnabled();
}

bool NetworkManagerProxy::isWwanEnabled()
{
  return NetworkManager::isWwanEnabled();
}

bool NetworkManagerProxy::isWimaxEnabled()
{
  return NetworkManager::isWimaxEnabled();
}

bool NetworkManagerProxy::isWwanHardwareEnabled()
{
  return NetworkManager::isWwanHardwareEnabled();
}

bool NetworkManagerProxy::isWirelessHardwareEnabled()
{
  return NetworkManager::isWimaxHardwareEnabled();
}

bool NetworkManagerProxy::isWimaxHardwareEnabled()
{
  return NetworkManager::isWimaxHardwareEnabled();
}

QDBusPendingReply<QDBusObjectPath> NetworkManagerProxy::activateConnection(const QString& connectionUni, const QString& interfaceUni, const QString& connectionParameter)
{
  return NetworkManager::activateConnection(connectionUni, interfaceUni, connectionParameter);
}

QDBusPendingReply<QDBusObjectPath, QDBusObjectPath> NetworkManagerProxy::addAndActivateConnection(const NMVariantMapMap& connection, const QString& interfaceUni, const QString& connectionParameter)
{
  return NetworkManager::addAndActivateConnection(connection, interfaceUni, connectionParameter);
}

void NetworkManagerProxy::deactivateConnection(const QString& activeConnection)
{
  NetworkManager::deactivateConnection(activeConnection);
}

QQmlListProperty<NetworkManager::ActiveConnection> NetworkManagerProxy::activeConnections()
{
  return QQmlListProperty<NetworkManager::ActiveConnection>(this, 0,
                                                                    activeConnectionAppendFunc,
                                                                    activeConnectionCountFunc,
                                                                    activeConnectionAtFunc,
                                                                    activeConnectionClearFunc);
}

QStringList NetworkManagerProxy::activeConnectionsPaths()
{
  return NetworkManager::activeConnectionsPaths();
}

NetworkManager::ActiveConnection::Ptr NetworkManagerProxy::findActiveConnection(const QString& uni)
{
  return NetworkManager::findActiveConnection(uni);
}

NetworkManager::Device::Types NetworkManagerProxy::supportedInterfaceTypes()
{
  return NetworkManager::supportedInterfaceTypes();
}

void NetworkManagerProxy::setNetworkingEnabled(bool enabled)
{
  NetworkManager::setNetworkingEnabled(enabled);
}

void NetworkManagerProxy::setWirelessEnabled(bool enabled)
{
  NetworkManager::setWirelessEnabled(enabled);
}

void NetworkManagerProxy::setWwanEnabled(bool enabled)
{
  NetworkManager::setWwanEnabled(enabled);
}

void NetworkManagerProxy::setWimaxEnabled(bool enabled)
{
  NetworkManager::setWimaxEnabled(enabled);
}
