import QtQuick 1.1

Rectangle {
  id: item
  height: 48

  property alias text: title.text
  property alias icon: icon.source
  default property alias additionalItems: additionalItemsContainer.children
  property bool selected: false
  signal clicked()

  color: selected ? "#ddd" : "transparent"

  MouseArea { anchors.fill: parent; onClicked: item.clicked() }

  Image {
    id: icon
    asynchronous: true
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
    font.pixelSize: 20
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: icon.right
    anchors.margins: 16
    width: 256
    elide: Text.ElideRight
  }

  Row {
    id: additionalItemsContainer
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: title.right
    anchors.right: parent.right
    anchors.margins: 16
  }

  Rectangle {
    width: parent.width
    height: 1
    color: "#ddd"
    anchors.bottom: parent.bottom
  }

  GuiHint {
    control: "game-b"
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 4
    opacity: selected ? 1.0 : 0.0
  }
}
