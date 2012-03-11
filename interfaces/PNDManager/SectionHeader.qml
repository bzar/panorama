import QtQuick 1.1

Rectangle {
  property alias text: title.text
  height: 32
  color: "#ccc"
  Text {
    id: title
    font.pixelSize: 24
    anchors.verticalCenter: parent.verticalCenter
  }
}
