import QtQuick 1.1
import Panorama.Settings 1.0
import Panorama.UI 1.0
import Panorama.NetworkManager 1.0

PanoramaUI {
  id: ui
  name: "PNDManager"
  description: "PND Manager application"
  author: "B-ZaR"
  anchors.fill: parent

  NetworkManager {
    id: net
  }

  Text {
    anchors.centerIn: parent
    color: "#fff"
    text: net.networkingEnabled + ' ' + net.wirelessEnabled + ' ' + net.activeConnections
  }
}
