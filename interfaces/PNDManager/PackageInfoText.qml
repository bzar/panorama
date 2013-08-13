import QtQuick 2.0

Item {
  property alias label: label.text
  property alias text: content.text
  height: childrenRect.height
  width: parent.width
  Text {
    id: label
    font.pixelSize: 14
    width: 90
  }
  Text {
    id: content
    font.pixelSize: 14
    elide: Text.ElideRight
    width: parent.width - label.width
    x: label.width
  }
}
