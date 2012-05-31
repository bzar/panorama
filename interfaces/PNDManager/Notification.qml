import QtQuick 1.1

Rectangle {
  property alias text: notificationText.text
  function show() {
    opacity = 1.0;
    fadeOut.start()
  }

  PropertyAnimation on opacity {
    id: fadeOut
    to: 0
    duration: 2000
  }
  opacity: 0
  visible: opacity != 0
  width: notificationText.paintedWidth + radius
  height: notificationText.paintedHeight + radius
  radius: 32
  color: "#111"

  Text {
    id: notificationText
    anchors.centerIn: parent
    font.pixelSize: 32
    color: "#fff"
  }

}
