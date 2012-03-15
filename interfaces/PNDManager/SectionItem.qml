import QtQuick 1.1

Item {
  id: item
  height: 32

  property alias text: title.text
  property alias icon: icon.source
  default property alias additionalItems: additionalItemsContainer.children
  signal clicked()

  MouseArea { anchors.fill: parent; onClicked: item.clicked() }

  Image {
    id: icon
    asynchronous: true
    anchors.left: parent.left
    sourceSize.width: 32
    sourceSize.height: 32
  }

  Text {
    id: title
    font.pixelSize: 20
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: icon.right
    width: 256
    elide: Text.ElideRight
  }

  Row {
    id: additionalItemsContainer
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: title.right
    anchors.right: parent.right
  }

  Rectangle {
    width: parent.width
    height: 1
    color: "#ddd"
    anchors.bottom: parent.bottom
  }
}
