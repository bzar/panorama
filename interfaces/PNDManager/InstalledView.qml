import QtQuick 1.1

import "util.js" as Utils

View {
  viewTitle: "Installed"

  property QtObject pndManager

  function showPackage(pnd) {
    stack.push(packageView, { "pnd": pnd, "viewTitle": pnd.title, "pndManager": pndManager });
  }

  Component { id: packageView; PackageView {} }

  Rectangle {
    anchors.fill: parent
    color: "white"

    Text {
      text: "Nothing installed"
      font.pixelSize: 20
      anchors.centerIn: parent
      visible: !(installed.visible || downloading.visible || upgradable.visible)
    }

    Rectangle {
      width: 16
      height: content.height * content.height / content.contentHeight
      anchors.right: parent.right
      y: (content.height - height) * content.contentY / (content.contentHeight - content.height)
      color: "#111"
      visible: content.moving
      z: 1
    }

    Flickable {
      id: content
      anchors.fill: parent
      contentHeight: itemsColumn.height
      contentWidth: width
      boundsBehavior: Flickable.DragOverBounds

      Column {
        id: itemsColumn
        height: childrenRect.height
        width: parent.width

        SectionHeader {
          id: downloading
          text: "Downloading"
          width: parent.width
          visible: downloadingRepeater.model.length > 0
        }

        Connections {
          target: pndManager
          onPackagesChanged: {
            downloadingRepeater.refresh()
            upgradableRepeater.refresh()
            installedRepeater.refresh()
          }
        }

        Repeater {
          id: downloadingRepeater
          model: []
          function refresh() { model = pndManager.packages.downloading().all(); }

          delegate: SectionItem {
            width: content.width
            text: modelData.title ? modelData.title : modelData.id
            icon: modelData.icon
            onClicked: showPackage(modelData)

            Rectangle {
              color: "#ddd"
              radius: 8
              height: 16
              width: 128

              ProgressBar {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 4
                height: 8
                radius: 4
                color: "#333"
                minimumValue: 0
                maximumValue: modelData.bytesToDownload
                value: modelData.bytesDownloaded
              }
            }
            Item {
              id: progressText
              property variant progress: Utils.prettyProgress(modelData.bytesDownloaded, modelData.bytesToDownload)
              width: 256
              height: 16
              Text {
                text: progressText.progress.value
                font.pixelSize: 14
                anchors.right: totalSize.left
              }
              Text {
                id: totalSize
                text: " / " + progressText.progress.size + " " + progressText.progress.unit
                font.pixelSize: 14
                anchors.right: parent.right
              }
            }
          }
        }

        SectionHeader {
          id: upgradable
          text: "Upgradable"
          width: parent.width
          visible: upgradableRepeater.model.length > 0

          Button {
            label: "Upgrade all"
            color: "#6992D7"
            width: 128
            height: 24
            radius: 4
            onClicked: {
              var pnds = upgradableRepeater.model;
              for(var i = 0; i < pnds.length; ++i) {
                pnds[i].upgrade();
              }
            }

            anchors.margins: 4
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
          }

        }
        Repeater {
          id: upgradableRepeater
          model: []
          function refresh() { model = pndManager.packages.installed().upgradable().notDownloading().all() }
          delegate: SectionItem {
            width: content.width
            text: modelData.title ? modelData.title : modelData.id
            icon: modelData.icon
            onClicked: showPackage(modelData)
          }
        }

        SectionHeader {
          id: installed
          text: "Installed"
          width: parent.width
          visible: installedRepeater.model.length > 0
        }
        Repeater {
          id: installedRepeater
          model: []
          function refresh() { model = pndManager.packages.installed().notUpgradable().notDownloading().all() }
          delegate: SectionItem {
            width: content.width
            text: modelData.title ? modelData.title : modelData.id
            icon: modelData.icon
            onClicked: showPackage(modelData)
          }
        }
      }
    }
  }
}

