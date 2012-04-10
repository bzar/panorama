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

  onInstallUpgradeButton: upgradeAll()
  onRemoveButton: cancelDownload()
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
    if(content.currentItem) {
      return content.currentItem.pnd;
    } else {
      return null;
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
    visible: installedModelPrefilter.length === 0 && downloadingModelPrefilter.length === 0 && upgradableModelPrefilter.length === 0
  }

  ScrollBar {
    id: scrollbar
    target: content
    z: 3
    anchors.right: content.right
    Connections {
      target: content
      onMovementStarted: scrollbar.show()
      onMovementEnded: scrollbar.hide()
      onCurrentIndexChanged: scrollbar.showIfChanged(content.contentY)
    }

  }

  ListView {
    id: content
    anchors.left: parent.left
    anchors.right: info.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom

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
          append({sect: sectionDownloading, item: downloadingModel[i]});
        }
        for(var i = 0; i < upgradableModel.length; ++i) {
          append({sect: sectionUpgradable, item: upgradableModel[i]});
        }
        for(var i = 0; i < installedModel.length; ++i) {
          append({sect: sectionInstalled, item: installedModel[i]});
        }
        return 1;
      }
    }

    boundsBehavior: Flickable.DragOverBounds
    onCurrentItemChanged: if(currentIndex === 0 && packages.count > 1) positionViewAtBeginning()

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

    highlightFollowsCurrentItem: false

    highlight: Rectangle {
      color: "#ddd"
      width: content.currentItem ? content.currentItem.width : 0
      height: content.currentItem ? content.currentItem.height : 0
      visible: content.currentItem != null

      Connections {
        target: content
        onCurrentIndexChanged: y = content.currentItem ? content.currentItem.y : 0
      }
    }

    delegate: SectionItem {
      width: content.width
      title: item.title ? item.title : item.id
      icon: item.icon
      progress: item.isDownloading ? Math.floor(100 * item.bytesDownloaded / item.bytesToDownload) + "%" : ""
      onClicked: {
        if(content.currentIndex === index) {
          openSelected();
        } else {
          content.currentIndex = index;
        }
      }
      property QtObject pnd: item
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

      Button {
        id: upgradeAllButton
        label: "Upgrade all"
        color: Theme.colors.upgrade
        control: "game-y"
        width: 192
        height: 32
        radius: 4
        onClicked: upgradeAll()
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 8
        visible: section == packages.sectionUpgradable
      }
    }
  }

  Rectangle {
    id: info
    width: 256
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    property QtObject pnd: getSelected()

    color: "#f8f8f8"

    Rectangle {
      id: infoSeparator
      width: 1
      height: parent.height
      color: "#ccc"
      anchors.left: parent.left
    }

    Column {
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 8
      height: childrenRect.height
      spacing: 2

      Text {
        text: info.pnd ? info.pnd.title : "-"
        font.pixelSize: 16
        font.bold: Font.DemiBold
        width: parent.width
      }
      Rectangle {
        width: parent.width
        height: 1
        color: "#ddd"
      }
      PackageInfoText {
        label: "Author"
        text: info.pnd && info.pnd.author.name ? info.pnd.author.name : "-"
      }
      PackageInfoText {
        label: "Rating"
        text: pndUtils.createRatingString(info.pnd)
      }
      PackageInfoText {
        label: "Size:"
        text: info.pnd ? Utils.prettySize(info.pnd.size) : "-"
      }
      PackageInfoText {
        label: "Version:"
        text: info.pnd ? Utils.versionString(info.pnd.version) : "-"
      }
      PackageInfoText {
        label: "Location:"
        text: info.pnd ? info.pnd.mount : "-"
      }
      Rectangle {
        width: parent.width
        height: 1
        color: "#ddd"
        visible: info.pnd !== null && info.pnd.upgradeCandidate !== null
      }
      Text {
        font.pixelSize: 14
        text: "Upgrade"
        font.bold: Font.DemiBold
        visible: info.pnd !== null && info.pnd.upgradeCandidate !== null && !info.pnd.isDownloading
      }
      PackageInfoText {
        label: "Size:"
        text: visible ? Utils.prettySize(info.pnd.upgradeCandidate.size) : ""
        visible: info.pnd !== null && info.pnd.upgradeCandidate !== null && !info.pnd.isDownloading
      }
      PackageInfoText {
        label: "Version:"
        text: visible ? Utils.versionString(info.pnd.upgradeCandidate.version) : ""
        visible: info.pnd !== null && info.pnd.upgradeCandidate !== null && !info.pnd.isDownloading
      }

      Item {
        width: parent.width
        height: 16
        visible: info.pnd !== null && info.pnd.isDownloading

        Rectangle {
          id: progressBar
          color: "#ddd"
          radius: 8
          height: 16

          anchors.left: parent.left
          anchors.right: downloadCancelButton.left
          anchors.margins: 4

          Connections {
            target: info.pnd
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
            maximumValue: !info.pnd ? 0 : info.pnd.bytesToDownload
            value: !info.pnd ? 0 : info.pnd.bytesDownloaded
          }
        }
        Image {
          id: downloadCancelButton
          source: "img/x_alt_32x32.png"
          width: 16
          height: 16
          smooth: true
          anchors.right: parent.right
          anchors.rightMargin: 20

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
        visible: info.pnd !== null && info.pnd.isDownloading
        property variant progress: !visible ? null : Utils.prettyProgress(info.pnd.bytesDownloaded, info.pnd.bytesToDownload)
        width: parent.width
        height: 16
        Text {
          text: progressText.progress ? progressText.progress.value : ""
          font.pixelSize: 14
          anchors.right: totalSize.left
        }
        Text {
          id: totalSize
          text: progressText.progress ? " / " + progressText.progress.size + " " + progressText.progress.unit : ""
          font.pixelSize: 14
          anchors.right: parent.right
        }
      }

      Rectangle {
        width: parent.width
        height: 1
        color: "#ddd"
      }
      Text {
        text: info.pnd ? info.pnd.description.split("\n")[0] : ""
        width: parent.width
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
        maximumLineCount: 4
      }
    }

    Button {
      id: showButton
      label: "Show"
      control: "game-b"
      color: "#555"
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.margins: 8
      height: 64
      radius: 4
      onClicked: openSelected()
    }
  }

  Rectangle {
    opacity: 0.8
    height: 32
    anchors.bottomMargin: search.text != "" ? 0 : -(height+1)
    anchors.bottom: content.bottom
    anchors.left: content.left
    anchors.right: content.right
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
      cursorVisible: true
      Keys.onRightPressed: event.accepted = true
      Keys.onLeftPressed: event.accepted = true
    }
  }
}


