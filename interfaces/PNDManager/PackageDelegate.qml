import QtQuick 1.1

Item {
  id: packageDelegate
  property QtObject pnd
  property bool showSize: true
  default property alias children: content.children

  signal clicked()

  Image {
    id: icon
    source: pnd.icon
    asynchronous: true
    height: 48
    width: 48
    fillMode: Image.PreserveAspectFit
    sourceSize {
      height: 48
      width: 48
    }
  }

  Text {
    id: title
    text: pnd.title
    anchors.left: icon.right
    anchors.right: parent.right
    elide: Text.ElideRight
    font.pixelSize: 16
    font.underline: true
    anchors.leftMargin: 8
  }

  Item {
    id: content
    anchors.left: icon.right
    anchors.right: parent.right
    anchors.top: title.bottom
    anchors.bottom: parent.bottom
    anchors.leftMargin: 8
  }

  MouseArea {
    anchors.fill: parent
    onClicked: packageDelegate.clicked()
  }
}
