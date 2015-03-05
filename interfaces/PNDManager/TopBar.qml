import QtQuick 1.1

Rectangle {
  id: bar
  property string title
  property bool showCloseButton

  signal closeButtonClicked()
  signal settingsButtonClicked()

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

  Row {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    spacing: 4
    GuiHint {
      control: "keyboardfnlayer-f10"
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: height
    }
    Image {
      source: "img/settings_gear.png"
      smooth: true
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: height
      anchors.margins: 4
      fillMode: Image.PreserveAspectFit
      MouseArea { anchors.fill: parent; onClicked: bar.settingsButtonClicked() }
    }
    GuiHint {
      control: "keyboardfnlayer-f12"
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: height
      show: closeButton.visible
    }
    Image {
      id: closeButton
      source: "img/x_28x28.png"
      smooth: true
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      width: height
      anchors.margins: 4
      fillMode: Image.PreserveAspectFit
      visible: bar.showCloseButton
      MouseArea { anchors.fill: parent; onClicked: bar.closeButtonClicked() }
    }
  }


}
