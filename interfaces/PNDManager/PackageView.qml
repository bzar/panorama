import QtQuick 1.1

import "util.js" as Utils

View {
  property QtObject pnd
  property QtObject pndManager

  Component {
    id: installDialog
    InstallLocationDialog {

    }
  }

  Rectangle {
    anchors.fill: parent
    color: "white"
    Text {
      id: titleText
      text: pnd.title
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      horizontalAlignment: Text.Center
      font.pixelSize: 42
    }

    Row {
      anchors.top: titleText.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 16
      Button {
        label: "Install (" + Utils.prettySize(pnd.size) + ")"
        color: "#69D772"
        width: 256
        height: 64
        radius: 4
        visible: !pnd.installed && !pnd.isDownloading
        onClicked: stack.push(installDialog, {"pndManager": pndManager, "pnd": pnd});
      }
      Button {
        label: "Remove"
        color: "#D76D69"
        width: 256
        height: 64
        radius: 4
        visible: pnd.installed && !pnd.isDownloading
        onClicked: pnd.remove()
      }
      Button {
        label: !pnd.upgradeCandidate ? "" : "Upgrade (" + Utils.prettySize(pnd.upgradeCandidate.size) + ")"
        sublabel: !pnd.upgradeCandidate ? "" : pnd.version.toString() + " -> " + pnd.upgradeCandidate.version.toString()
        color: "#6992D7"
        width: 256
        height: 64
        radius: 4
        visible: pnd.installed && pnd.hasUpgrade && !pnd.isDownloading
        onClicked: pnd.upgrade()
      }
      Column {
        width: 256
        height: 64
        visible: pnd.isDownloading
        Text {
          text: "Installing..."
          anchors.left: parent.left
          anchors.margins: 16
        }
        Rectangle {
          anchors.left: parent.left
          anchors.right: parent.right
          color: "#ddd"
          radius: 24
          height: 48

          ProgressBar {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 8
            height: 32
            radius: 16
            color: "#333"
            minimumValue: 0
            maximumValue: pnd.bytesToDownload
            value: pnd.bytesDownloaded
          }
        }
        Item {
          anchors.right: parent.right
          anchors.margins: 16
          property variant progress: Utils.prettyProgress(pnd.bytesDownloaded, pnd.bytesToDownload)
          Text {
            text: parent.progress.value
            anchors.right: totalSize.left
          }
          Text {
            id: totalSize
            anchors.right: parent.right
            text: " / " + parent.progress.size + " " + parent.progress.unit
          }
        }
      }
    }
  }

  Keys.onPressed: {
      if(event.key === Qt.Key_Backspace) {
          stack.pop()
      }
  }

}

