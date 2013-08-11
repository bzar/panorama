import QtQuick 2.0

ListView {
  id: listView
  Rectangle {
    height: 1
    color: "#eee"
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    z: 1
  }

  Rectangle {
    height: 1
    color: "#eee"
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    z: 1
  }

  ScrollBar {
    id: scrollbar
    anchors.right: parent.right
    Connections {
      target: listView
      onMovementStarted: scrollbar.show()
      onMovementEnded: scrollbar.hide()
      onCurrentIndexChanged: scrollbar.showIfChanged(contentY)
    }
  }

}

