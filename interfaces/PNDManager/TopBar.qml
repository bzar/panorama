import QtQuick 1.1

Rectangle {
  id: bar
  property string title
  property bool showCloseButton

  signal closeButtonClicked()

  MouseArea { anchors.fill: parent; onPressed: mouse.accepted = true; }

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

  Image {
    source: "img/x_28x28.png"
    smooth: true
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 4
    fillMode: Image.PreserveAspectFit
    visible: bar.showCloseButton
    MouseArea { anchors.fill: parent; onClicked: bar.closeButtonClicked() }
    GuiHint {
      control: "keyboardfnlayer-f12"
      height: parent.height
      width: height
      anchors.right: parent.left
      anchors.margins: 4
    }
  }
}
