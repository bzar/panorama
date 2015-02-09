// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "theme.js" as Theme

Rectangle {
  id: dialog
  color: "#fff"

  signal hide()
  signal dontShowAgain()

  Image {
    id: compoBanner
    source: "img/rebirth-banner.jpg"
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    fillMode: Image.PreserveAspectFit
    smooth: true
  }

  Text {
    id: welcomeText
    text: "Welcome to PNDManager!"
    font.pixelSize: 32
    height: paintedHeight
    anchors.top: compoBanner.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.margins: 8
    font.underline: true
    color: "#111"
    style: Text.Raised
    styleColor: "#ccc"
  }
  Item {
    anchors.top: welcomeText.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: buttons.top
    anchors.margins: 16

    Row {
      id: controls
      anchors.centerIn: parent

      spacing: 64
      Column {
        spacing: 4
        ControlHelp { control: "use-dpad"; label: "Move cursor" }
        ControlHelp { control: okButtonGuiHintControl; label: "Yes, more information, next" }
        ControlHelp { control: "game-a"; label: "No, remove, cancel" }
        ControlHelp { control: "shoulder-l"; label: "Change mode left" }
        ControlHelp { control: "keyboardfnlayer-f1"; label: "Show/hide control hints" }
        ControlHelp { control: "keyboard-enter"; label: "Launch PND / search" }
      }

      Column {
        spacing: 4
        ControlHelp { control: "start"; label: "Synchronize with server" }
        ControlHelp { control: okButtonGuiHintControl; label: "Back" }
        ControlHelp { control: "game-y"; label: "Install/upgrade" }
        ControlHelp { control: "shoulder-r"; label: "Change mode right" }
        ControlHelp { control: "select"; label: "Change package sorting" }
      }

    }
  }

  Row {
    id: buttons
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.margins: 8
    spacing: 32

    Button {
      label: "Don't show next time"
      width: 272
      height: 48
      radius: 8
      onClicked: { dialog.dontShowAgain(); dialog.hide() }
      color: Theme.colors.no
      control: "game-a"
    }

    Button {
      label: "Show next time"
      width: 272
      height: 48
      radius: 8
      onClicked: dialog.hide()
      color: Theme.colors.yes
      control: okButtonGuiHintControl
    }
  }
}
