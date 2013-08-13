import QtQuick 2.0

Item {
  id: item
  height: 54

  property alias title: title.text
  property alias icon: icon.source
  property alias progress: progress.text
  signal clicked()

  MouseArea { anchors.fill: parent; onClicked: item.clicked() }

  Image {
    id: icon
    asynchronous: true
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: (48/2 - width/2) + 4
    sourceSize.width: 48
  }

  Text {
    id: title
    font.pixelSize: 20
    height: parent.height
    verticalAlignment: Text.AlignVCenter
    anchors.left: parent.left
    anchors.right: progress.left
    anchors.leftMargin: 64
    elide: Text.ElideRight
  }

  Text {
    id: progress
    font.pixelSize: 14
    height: parent.height
    verticalAlignment: Text.AlignVCenter
    anchors.right: parent.right
    visible: text
    horizontalAlignment: Text.AlignRight
    width: 64
  }

  Rectangle {
    width: parent.width
    height: 1
    color: "#ddd"
    anchors.bottom: parent.bottom
  }
}
