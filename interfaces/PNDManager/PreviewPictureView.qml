import QtQuick 2.0

View {
  viewTitle: "Preview pictures"

  property variant previewPictures

  Keys.forwardTo: previewList

  ListView {
    id: previewList
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.right: parent.right
    height: parent.height * 0.9

    orientation: ListView.Horizontal
    snapMode: ListView.SnapToItem
    flickDeceleration: 2500

    preferredHighlightBegin: width/2 - currentItem.width/2
    preferredHighlightEnd: width/2 + currentItem.width/2
    highlightRangeMode: ListView.StrictlyEnforceRange

    cacheBuffer: width*4
    spacing: 16
    boundsBehavior: ListView.DragOverBounds

    model: previewPictures

    delegate: Rectangle {
      color: image.status == Image.Ready ? "#00000000" : "#eee"
      height: previewList.height
      width: image.status == Image.Ready ? image.width : height

      Text {
        anchors.centerIn: parent
        visible: image.status != Image.Ready
        text: parseInt(image.progress * 100) + "%"
        font.pixelSize: 24
      }

      Image {
        id: image
        source: src
        sourceSize {
          height: parent.height
        }
        anchors.verticalCenter: parent.verticalCenter
      }
    }
  }
}
