// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

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
  }

  Row {
    id: buttons
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.margins: 16
    spacing: 32

    Button {
      label: "Show next time"
      width: 256
      height: 64
      radius: 8
      onClicked: dialog.hide()
    }

    Button {
      label: "Don't show next time"
      width: 256
      height: 64
      radius: 8
      onClicked: { dialog.dontShowAgain(); dialog.hide() }
    }
  }
}
