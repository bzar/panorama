import QtQuick 1.1

import "util.js" as Utils

View {
  property QtObject pnd
  property QtObject pndManager

  Component { id: installDialog; InstallLocationDialog {} }
  Component { id: previewPictureView; PreviewPictureView {} }

  Keys.forwardTo: textArea
  onOkButton: showPreviewPictures()
  onInstallRemoveButton: pnd.installed ? pnd.remove() : showInstallDialog()
  onUpgradeButton: upgrade()

  function showPreviewPictures() {
    if(pnd.previewPictures.length > 0) {
      stack.push(previewPictureView, { "previewPictures": pnd.previewPictures });
    }
  }

  function showInstallDialog() {
    if(!pnd.installed && !pnd.isDownloading) {
      stack.push(installDialog, {"pndManager": pndManager, "pnd": pnd});
    }
  }

  function upgrade() {
    if(pnd.installed && pnd.hasUpgrade && !pnd.isDownloading) {
      pnd.upgrade();
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
      id: buttons
      anchors.top: titleText.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 16
      Button {
        label: "Install"
        sublabel: Utils.prettySize(pnd.size)
        color: "#69D772"
        width: 256
        height: 64
        radius: 4
        visible: !pnd.installed && !pnd.isDownloading
        onClicked: showInstallDialog()
      }
      Button {
        label: "Remove"
        sublabel: Utils.prettySize(pnd.size)
        color: "#D76D69"
        width: 256
        height: 64
        radius: 4
        visible: pnd.installed && !pnd.isDownloading
        onClicked: pnd.remove()
      }
      Button {
        label: "Upgrade"
        sublabel: pnd.hasUpgrade ? Utils.versionString(pnd.version) + " → " + Utils.versionString(pnd.upgradeCandidate.version) + " (" + Utils.prettySize(pnd.upgradeCandidate.size) + ")" : ""
        color: "#6992D7"
        width: 256
        height: 64
        radius: 4
        visible: pnd.installed && pnd.hasUpgrade && !pnd.isDownloading
        onClicked: upgrade()
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

    Rectangle {
      height: 1
      color: "#eee"
      anchors.bottom: textArea.top
      anchors.left: textArea.left
      anchors.right: textArea.right
    }

    Flickable {
      id: textArea
      anchors.top: buttons.bottom
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.horizontalCenter
      anchors.margins: 16
      contentHeight: textAreaContents.height
      contentWidth: width
      clip: true

      Column {
        id: textAreaContents
        anchors.left: parent.left
        anchors.right: parent.right
        height: childrenRect.height
        spacing: 16

        Item {
          anchors.left: parent.left
          anchors.right: parent.right
          height: childrenRect.height

          Image {
            id: icon
            source: pnd.icon
            asynchronous: true
            height: 48
            width: 48
            fillMode: Image.PreserveAspectFit
            sourceSize {
              height: 48
              width: 48
            }
          }

          Column {
            height: childrenRect.height
            anchors.left: icon.right
            anchors.right: parent.right
            anchors.leftMargin: 8

            PackageInfoText {
              anchors.left: parent.left
              anchors.right: parent.right
              label: "Author:"
              text: pnd.author.name
            }

            PackageInfoText {
              anchors.left: parent.left
              anchors.right: parent.right
              label: "Rating:"

              function getRating() {
                var s = "";
                for(var i = 0; i < Math.ceil(pnd.rating/20); ++i) {
                  s += "★";
                }
                return s;
              }

              text: pnd.rating !== 0 ? getRating() : "(not rated)"
            }

            PackageInfoText {
              anchors.left: parent.left
              anchors.right: parent.right
              label: "Last updated:"
              text: Utils.prettyLastUpdatedString(pnd.modified)
            }
          }
        }

        Text {
          text: pnd.description
          anchors.left: parent.left
          anchors.right: parent.right
          wrapMode: Text.WrapAtWordBoundaryOrAnywhere
          font.pixelSize: 14
        }

      }
    }

    Rectangle {
      height: 1
      color: "#eee"
      anchors.top: textArea.bottom
      anchors.left: textArea.left
      anchors.right: textArea.right
    }

    Rectangle {
      anchors.top: buttons.bottom
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      anchors.margins: 16
      color: "#ccc"

      Image {
        id: image
        anchors.fill: parent
        source: pnd.previewPictures.length > 0 ? pnd.previewPictures[0].src : ""
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        smooth: true

        Text {
            anchors.centerIn: parent
            opacity: image.source != "" ? (image.status != Image.Ready && image.source != "" ? 1.0 : 0.0) : 1.0
            text: image.source != "" ? parseInt(image.progress * 100) + "%" : "No preview"
            font.pixelSize: 24
            color: "#777"
        }

        MouseArea {
          anchors.fill: parent
          onClicked: showPreviewPictures()
        }
      }
    }
  }
}

