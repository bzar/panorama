import QtQuick 1.1

Rectangle {
  id: bar
  property string title
  property bool showCloseButton: true
  property bool showSettingsButton: true

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
    anchors.right: parent.right
    spacing: 4
    GuiHint {
      control: "keyboardfnlayer-f9"
      opacity: 0.72
      anchors.verticalCenter: settingsButton.verticalCenter
      show: settingsButton.visible
    }
    Image {
      id: settingsButton
      source: "img/settings_gear_topbar.png"
      visible: showSettingsButton
      MouseArea { anchors.fill: parent; onClicked: bar.settingsButtonClicked() }
    }
    GuiHint {
      control: "keyboardfnlayer-f10"
      opacity: 0.72
      anchors.verticalCenter: closeButton.verticalCenter
      show: closeButton.visible
    }
    Image {
      id: closeButton
      source: "img/close_x_topbar.png"
      smooth: true
      visible: bar.showCloseButton
      MouseArea { anchors.fill: parent; onClicked: bar.closeButtonClicked() }
    }
  }


}
