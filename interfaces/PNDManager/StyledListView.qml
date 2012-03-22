import QtQuick 1.1

ListView {
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
  }
}

