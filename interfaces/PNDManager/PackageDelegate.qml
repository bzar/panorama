import QtQuick 2.0

Item {
  id: packageDelegate
  property QtObject pnd
  property bool showSize: true
  default property alias children: content.children

  signal clicked()

  height: childrenRect.height

  Image {
    id: icon
    source: pnd.installed ? "image://pnd/" + pnd.id : pnd.icon
    asynchronous: true
    anchors.leftMargin: (48/2 - width/2) + 4
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    sourceSize.width: 48
    sourceSize.height: 48
  }

  Column {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    Text {
      id: title
      text: pnd.title
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 64
      anchors.rightMargin: 8
      verticalAlignment: Text.Bottom
      elide: Text.ElideRight
      font.pixelSize: 14
      font.bold: true
    }

    Item {
      id: content
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 64
      height: childrenRect.height
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: packageDelegate.clicked()
  }
}
