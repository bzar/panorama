import QtQuick 1.1

Rectangle {
  id: bar
  property string title

  color: "#111"

  Text {
    text: title
    color: "#fff"

    font.pixelSize: bar.height - 8
    verticalAlignment: Text.AlignVCenter
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.margins: 8
  }
}
