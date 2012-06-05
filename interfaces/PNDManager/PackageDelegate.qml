import QtQuick 1.1

Item {
  id: packageDelegate
  property QtObject pnd
  property bool showSize: true
  default property alias children: content.children

  signal clicked()

  Image {
    id: icon
    source: pnd.installed ? "image://pnd/" + pnd.id : pnd.icon
    asynchronous: true
    anchors.leftMargin: (48/2 - width/2) + 4
    anchors.left: parent.left
    sourceSize.width: 48
  }

  Text {
    id: title
    text: pnd.title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 56
    anchors.rightMargin: 8
    elide: Text.ElideRight
    font.pixelSize: 16
    font.underline: true
  }

  Item {
    id: content
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: title.bottom
    anchors.bottom: parent.bottom
    anchors.leftMargin: 56
  }

  MouseArea {
    anchors.fill: parent
    onClicked: packageDelegate.clicked()
  }
}
