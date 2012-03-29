import QtQuick 1.1

import "util.js" as Utils

View {
  id: view
  viewTitle: "Installed"

  property QtObject pndManager
  property int itemCount: downloadingModel.length + upgradableModel.length + installedModel.length
  property int currentIndex: 0

  Keys.onUpPressed: currentIndex = Math.max(0, currentIndex - 1);
  Keys.onDownPressed: currentIndex = Math.min(itemCount - 1, currentIndex + 1);
  onOkButton: openSelected()

  Keys.priority: Keys.AfterItem
  Keys.forwardTo: [ui, search]
  Connections {
    target: pndManager
    onPackagesChanged: update()
  }

  onUpgradeButton: upgradeAll()
  onInstallRemoveButton: cancelDownload()

  function getDownloadingModelPrefilter() { return pndManager.packages.downloading().sortedByTitle() }
  function getUpgradableModelPrefilter() { return pndManager.packages.installed().upgradable().notDownloading().sortedByTitle() }
  function getInstalledModelPrefilter() { return pndManager.packages.installed().notUpgradable().notDownloading().sortedByTitle() }

  property QtObject downloadingModelPrefilter: getDownloadingModelPrefilter()
  property QtObject upgradableModelPrefilter: getUpgradableModelPrefilter()
  property QtObject installedModelPrefilter: getInstalledModelPrefilter()

  property variant downloadingModel: downloadingModelPrefilter.titleContains(search.text).all()
  property variant upgradableModel: upgradableModelPrefilter.titleContains(search.text).all()
  property variant installedModel: installedModelPrefilter.titleContains(search.text).all()


  function update() {
    downloadingModelPrefilter = getDownloadingModelPrefilter();
    upgradableModelPrefilter = getUpgradableModelPrefilter();
    installedModelPrefilter = getInstalledModelPrefilter();
  }

  function cancelDownload() {
    var pnd = getSelected();
    if(pnd.isDownloading) {
      pnd.cancelDownload();
      update();
    }

  }
  function showPackage(pnd) {
    stack.push(packageView, { "pnd": pnd, "viewTitle": pnd.title, "pndManager": pndManager });
  }

  function upgradeAll() {
    if(upgradableRepeater.model.length > 0) {
      var pnds = upgradableRepeater.model;
      for(var i = 0; i < pnds.length; ++i) {
        pnds[i].upgrade();
      }
    }
  }

  function getSelected() {
    if(currentIndex < downloadingModel.length) {
      return downloadingModel[currentIndex];
    } else if(currentIndex < downloadingModel.length + upgradableModel.length) {
      return upgradableModel[currentIndex - downloadingModel.length];
    } else if(currentIndex < downloadingModel.length + upgradableModel.length + installedModel.length) {
      return installedModel[currentIndex - downloadingModel.length - upgradableModel.length];
    }
  }
  function openSelected() {
    showPackage(getSelected());
  }

  Component { id: packageView; PackageView {} }

  Text {
    text: "Nothing installed"
    font.pixelSize: 20
    anchors.centerIn: parent
    visible: !(installed.visible || downloading.visible || upgradable.visible)
  }

  Rectangle {
    id: upgradeAllButtonContainer
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: visible ? upgradeAllButton.height + 16 : 0
    visible: upgradable.visible
    color: "#eee"
    Button {
      id: upgradeAllButton
      label: "Upgrade all"
      color: "#6992D7"
      control: "game-y"
      width: 256
      height: 64
      radius: 8
      onClicked: upgradeAll()
      anchors.centerIn: parent
    }
    Rectangle {
      height: 1
      color: "#ccc"
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
    }

  }

  Item {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: upgradeAllButtonContainer.bottom
    anchors.bottom: parent.bottom


    ScrollBar {
      id: scrollbar
      target: content
      z: 3
      anchors.right: parent.right
      Connections {
        target: content
        onMovementStarted: scrollbar.show()
        onMovementEnded: scrollbar.hide()
      }
      Connections {
        target: view
        onCurrentIndexChanged: scrollbar.showIfChanged(content.contentY)
      }
    }

    Flickable {
      id: content
      anchors.fill: parent
      contentHeight: itemsColumn.height
      contentWidth: width
      boundsBehavior: Flickable.DragOverBounds

      clip: true

      function ensureIntervalVisible(a, b) {
        var h = b - a;
        if(a - h < contentY) {
          contentY = a - h;
        }
        if(b + h > contentY + height) {
          contentY = b + h - height;
        }
      }

      Column {
        id: itemsColumn
        height: childrenRect.height
        width: parent.width

        SectionHeader {
          id: downloading
          icon: "img/cloud_download_32x32.png"
          text: "Downloading"
          width: parent.width
          visible: downloadingRepeater.model.length > 0
        }

        Repeater {
          id: downloadingRepeater
          model: downloadingModel

          delegate: SectionItem {
            property int itemIndex: index

            selected: view.currentIndex === itemIndex
            onSelectedChanged: content.ensureIntervalVisible(y, y + height)
            width: content.width
            text: modelData.title ? modelData.title : modelData.id
            icon: modelData.icon
            onClicked: { view.currentIndex = itemIndex; openSelected(); }

            Row {
              width: parent.width

              Rectangle {
                color: selected ? "#eee" : "#ddd"
                radius: 8
                height: 16
                width: parent.width / parent.children.length

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
                Image {
                  source: "img/x_alt_32x32.png"
                  width: 16
                  height: 16
                  smooth: true
                  anchors.left: parent.right
                  anchors.verticalCenter: parent.verticalCenter
                  anchors.margins: 16

                  GuiHint {
                    control: "game-a"
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    width: parent.width
                    anchors.margins: 4
                  }

                  MouseArea {
                    anchors.fill: parent
                    onClicked: cancelDownload()
                  }
                }
              }


              Item {
                id: progressText
                property variant progress: Utils.prettyProgress(modelData.bytesDownloaded, modelData.bytesToDownload)
                width: parent.width / parent.children.length
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
        }

        SectionHeader {
          id: upgradable
          text: "Upgradable"
          icon: "img/arrow_up_alt1_32x32.png"
          width: parent.width
          visible: upgradableRepeater.model.length > 0
        }
        Repeater {
          id: upgradableRepeater
          model: upgradableModel
          delegate: SectionItem {
            property int itemIndex: downloadingModel.length + index
            selected: view.currentIndex === itemIndex
            onSelectedChanged: content.ensureIntervalVisible(y, y + height)
            width: content.width
            text: modelData.title ? modelData.title : modelData.id
            icon: modelData.icon
            onClicked: { view.currentIndex = itemIndex; openSelected(); }

            Row {
              width: parent.width
              Text {
                width: parent.width / parent.children.length
                text: Utils.versionString(modelData.version) + " → " + Utils.versionString(modelData.upgradeCandidate.version)
                font.pixelSize: 14
              }
              Text {
                width: parent.width / parent.children.length
                text: Utils.prettySize(modelData.upgradeCandidate.size)
                font.pixelSize: 14
              }
              Text {
                width: parent.width / parent.children.length
                text: modelData.mount
                font.pixelSize: 14
              }
            }
          }
        }

        SectionHeader {
          id: installed
          text: "Installed"
          icon: "img/download_darkgrey_24x32.png"
          width: parent.width
          visible: installedRepeater.model.length > 0
        }
        Repeater {
          id: installedRepeater
          model: installedModel
          delegate: SectionItem {
            property int itemIndex: downloadingModel.length + upgradableModel.length + index
            selected: view.currentIndex === itemIndex
            onSelectedChanged: content.ensureIntervalVisible(y, y + height)
            width: content.width
            text: modelData.title ? modelData.title : modelData.id
            icon: modelData.icon
            onClicked: { view.currentIndex = itemIndex; openSelected(); }

            Row {
              width: parent.width
              Text {
                width: parent.width / parent.children.length
                text: Utils.versionString(modelData.version)
                font.pixelSize: 14
              }
              Text {
                width: parent.width / parent.children.length
                text: Utils.prettySize(modelData.size)
                font.pixelSize: 14
              }
              Text {
                width: parent.width / parent.children.length
                text: modelData.mount
                font.pixelSize: 14
              }
            }

          }
        }
      }
    }
  }

  Rectangle {
    opacity: 0.8
    height: 32
    anchors.bottomMargin: search.text != "" ? 0 : -(height+1)
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    color: "#eee"
    border {
      color: "#444"
      width: 1
    }

    TextInput {
      id: search
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 4
      font.pixelSize: 14
      activeFocusOnPress: false
    }
  }
}

