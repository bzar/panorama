import QtQuick 1.1

import "util.js" as Utils
import "theme.js" as Theme

View {
  id: view
  viewTitle: "Installed"

  property QtObject pndManager
  property bool sortByTitle: true

  onOkButton: openSelected()

  Keys.forwardTo: content
  Connections {
    target: pndManager
    onPackagesChanged: update()
  }

  onUpgradeButton: upgradeAll()
  onInstallRemoveButton: cancelDownload()
  onSelectButton: view.sortByTitle = !view.sortByTitle

  function sort(list) {
    if(sortByTitle) {
      return list.sortedByTitle()
    } else {
      return list.sortedByLastUpdated()
    }
  }

  function getDownloadingModelPrefilter() { return pndManager.packages.downloading() }
  function getUpgradableModelPrefilter() { return pndManager.packages.installed().upgradable().notDownloading() }
  function getInstalledModelPrefilter() { return pndManager.packages.installed().notUpgradable().notDownloading() }

  property QtObject downloadingModelPrefilter: getDownloadingModelPrefilter()
  property QtObject upgradableModelPrefilter: getUpgradableModelPrefilter()
  property QtObject installedModelPrefilter: getInstalledModelPrefilter()

  property QtObject downloadingModelSorted: sort(downloadingModelPrefilter)
  property QtObject upgradableModelSorted: sort(upgradableModelPrefilter)
  property QtObject installedModelSorted: sort(installedModelPrefilter)

  property variant downloadingModel: downloadingModelSorted.titleContains(search.text).all()
  property variant upgradableModel: upgradableModelSorted.titleContains(search.text).all()
  property variant installedModel: installedModelSorted.titleContains(search.text).all()

  function update() {
    downloadingModelPrefilter = getDownloadingModelPrefilter();
    upgradableModelPrefilter = getUpgradableModelPrefilter();
    installedModelPrefilter = getInstalledModelPrefilter();
    packages.createModel()
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
    for(var i = 0; i < upgradableModel.length; ++i) {
      upgradableModel[i].upgrade();
    }
  }

  function getSelected() {
    return content.currentItem.pkg;
  }
  function openSelected() {
    showPackage(getSelected());
  }

  Component { id: packageView; PackageView {} }

  Text {
    text: "Nothing installed"
    font.pixelSize: 20
    anchors.centerIn: parent
    visible: installedModelPrefilter.length === 0 && downloadingModelPrefilter.length === 0 && upgradableModelPrefilter.length === 0
  }

  Rectangle {
    id: upgradeAllButtonContainer
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: visible ? upgradeAllButton.height + 16 : 0
    visible: upgradableModel.length > 0
    color: "#eee"
    z: 1
    Button {
      id: upgradeAllButton
      label: "Upgrade all"
      color: Theme.colors.upgrade
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
        onCurrentIndexChanged: scrollbar.showIfChanged(content.contentY)
      }

    }

    ListView {
      id: content
      anchors.fill: parent

      Keys.priority: Keys.AfterItem
      Keys.forwardTo: [ui, search]

      model: ListModel {
        id: packages

        property int sectionDownloading: 1
        property int sectionUpgradable: 2
        property int sectionInstalled: 3
        property int foo: createModel() // hack to make model update automatically
        function createModel() {
          clear();
          for(var i = 0; i < downloadingModel.length; ++i) {
            append({sect: sectionDownloading, pnd: downloadingModel[i]});
          }
          for(var i = 0; i < upgradableModel.length; ++i) {
            append({sect: sectionUpgradable, pnd: upgradableModel[i]});
          }
          for(var i = 0; i < installedModel.length; ++i) {
            append({sect: sectionInstalled, pnd: installedModel[i]});
          }
          return 1;
        }
      }

      boundsBehavior: Flickable.DragOverBounds

      Component {
        id: downloadingComponent
        Item {
          Row {
            width: parent.width

            Rectangle {
              color: selected ? "#eee" : "#ddd"
              radius: 8
              height: 16
              width: parent.width / parent.children.length

              Connections {
                target: pndd
                onDownloadCancelled: view.update()
              }

              ProgressBar {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 4
                height: 8
                radius: 4
                color: "#333"
                minimumValue: 0
                maximumValue: pndd.bytesToDownload
                value: pndd.bytesDownloaded
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
              property variant progress: Utils.prettyProgress(pndd.bytesDownloaded, pndd.bytesToDownload)
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

      Component {
        id: upgradableComponent
        Row {
          width: parent.width
          Text {
            width: parent.width / parent.children.length
            text: Utils.versionString(pndd.version) + " → " + Utils.versionString(pndd.upgradeCandidate.version)
            font.pixelSize: 14
          }
          Text {
            width: parent.width / parent.children.length
            text: Utils.prettySize(pndd.upgradeCandidate.size)
            font.pixelSize: 14
          }
          Text {
            width: parent.width / parent.children.length
            text: pndd.mount
            font.pixelSize: 14
          }
        }
      }

      Component {
        id: installedComponent
        Row {
          width: parent.width
          Text {
            width: parent.width / parent.children.length
            text: Utils.versionString(pndd.version)
            font.pixelSize: 14
          }
          Text {
            width: parent.width / parent.children.length
            text: Utils.prettySize(pndd.size)
            font.pixelSize: 14
          }
          Text {
            width: parent.width / parent.children.length
            text: pndd.mount
            font.pixelSize: 14
          }
        }
      }

      header: Item {
        height: 64
        width: content.width
        Row {
          spacing: 32
          anchors.centerIn: parent

          Text {
            text: "Sorting:"
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 16
          }
          Rectangle {
            property bool selected: view.sortByTitle
            width: sortByTitleText.paintedWidth + 32
            height: 48
            color: selected ? "#555" : "#eee"
            radius: 8
            Text {
              anchors.centerIn: parent
              id: sortByTitleText
              text: "alphabetical"
              color: parent.selected ? "white" : "black"
              font.pixelSize: 16
            }

            MouseArea {
              anchors.fill: parent
              onClicked: view.sortByTitle = true
            }
          }

          Rectangle {
            property bool selected: !view.sortByTitle
            width: sortByDateText.paintedWidth + 32
            height: 48
            color: selected ? "#555" : "#eee"
            radius: 8
            Text {
              anchors.centerIn: parent
              id: sortByDateText
              text: "last updated"
              color: parent.selected ? "white" : "black"
              font.pixelSize: 16
            }

            MouseArea {
              anchors.fill: parent
              onClicked: view.sortByTitle = false
            }
          }

          GuiHint {
            control: "select"
            anchors.verticalCenter: parent.verticalCenter
            width: 32
            height: 32
          }
        }
      }

      delegate: SectionItem {
        width: content.width
        text: pnd.title ? pnd.title : pnd.id
        icon: pnd.icon
        onClicked: { content.currentIndex = index; openSelected(); }
        selected: index === content.currentIndex
        property QtObject pkg: pnd
        Loader {
          function getSource() {
            if(sect == packages.sectionDownloading) {
              return downloadingComponent;
            } else if(sect == packages.sectionUpgradable) {
              return upgradableComponent;
            } else if(sect == packages.sectionInstalled) {
              return installedComponent;
            }
          }

          property QtObject pndd: pkg
          property bool selected: index === content.currentIndex
          sourceComponent: getSource()
          width: parent.width
        }
      }

      section.property: "sect"
      section.delegate: SectionHeader {
        function getText() {
          if(section == packages.sectionDownloading) {
            return "Downloading"
          } else if(section == packages.sectionUpgradable) {
            return "Upgradable"
          } else if(section == packages.sectionInstalled) {
            return "Installed"
          }
          else return "N/A"
        }

        function getIcon() {
          if(section == packages.sectionDownloading) {
            return "img/cloud_download_32x32.png"
          } else if(section == packages.sectionUpgradable) {
            return "img/arrow_up_alt1_32x32.png"
          } else if(section == packages.sectionInstalled) {
            return "img/download_darkgrey_24x32.png"
          }
          else return ""
        }

        text: getText()
        icon: getIcon()
        width: parent.width
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


