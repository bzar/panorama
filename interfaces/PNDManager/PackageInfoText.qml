import QtQuick 1.1

Item {
  property alias label: label.text
  property alias text: content.text
  height: childrenRect.height

  Text {
    id: label
    font.pixelSize: 14
    width: 112
  }
  Text {
    id: content
    font.pixelSize: 14
    elide: Text.ElideRight
    width: parent.width - label.width
    x: label.width
  }
}
