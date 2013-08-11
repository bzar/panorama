import QtQuick 2.0

Rectangle {
  property alias text: title.text
  property alias icon: icon.source
  height: 48
  color: "#ccc"
  Image {
    id: icon
    asynchronous: true
    smooth: true
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 8
    sourceSize.width: 32
    sourceSize.height: 32
    width: 32
    height: 32
  }

  Text {
    id: title
    font.pixelSize: 32
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: icon.right
    anchors.margins: 16
  }
}
