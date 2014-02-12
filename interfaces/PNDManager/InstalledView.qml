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

  function cancelDownload() {
    var pnd = getSelected();
    if(pnd && (pnd.isDownloading || pnd.isQueued)) {
      pnd.cancelDownload();
      packages.createModel()
    }

  }
  function showPackage(pnd) {
    stack.push(packageView, { "pnd": pnd, "viewTitle": pnd.title, "pndManager": pndManager });
  }

  function upgradeAll() {
    for(var i = 0; i < packages.count; ++i) {
      var pnd = packages.get(i).item;
      if(pnd.hasUpgrade && !pnd.isDownloading && !pnd.isQueued) {
        pnd.upgrade();
      }
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

  function executeSelected() {
    if(getSelected() !== null && !pndManager.applicationRunning) {
      pndManager.execute(getSelected().id)
    }
  }

  Notification {
    id: downloadErrorNotification
    text: "Error downloading PND!"
    anchors.centerIn: parent
    z: 2
  }

  Component { id: packageView; PackageView {} }

  Text {
    text: "Nothing installed"
    font.pixelSize: 20
    anchors.centerIn: parent
    visible: packages.count === 0 && search.text === ""
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
    Keys.forwardTo: [keyHandler, ui, search]

    Item {
      id: keyHandler
      Keys.onLeftPressed: {
        content.currentIndex = Math.max(0, content.currentIndex - 5)
        event.accepted = true;
      }
      Keys.onRightPressed: {
        content.currentIndex = Math.min(content.count  - 1, content.currentIndex + 5)
        event.accepted = true;
      }
      Keys.onReturnPressed: executeSelected()
    }

    model: ListModel {
      id: packages

      property int sectionDownloading: 1
      property int sectionQueued: 2
      property int sectionUpgradable: 3
      property int sectionInstalled: 4

      function createModel() {
        var previousIndex = content.currentIndex;

        clear();
        var downloading = sort(pndManager.packages.downloading().notQueued()).titleContains(search.text).packages;
        var queued = sort(pndManager.packages.queued()).titleContains(search.text).packages;
        var installed = sort(pndManager.packages.installed().notDownloading());
        var upgradable = installed.copy().upgradable().notQueued().titleContains(search.text).packages;
        installed = installed.notUpgradable().titleContains(search.text).packages

        for(var i = 0; i < downloading.length; ++i) {
          append({sect: sectionDownloading, item: downloading[i]});
        }
        for(var i = 0; i < queued.length; ++i) {
          append({sect: sectionQueued, item: queued[i]});
        }
        for(var i = 0; i < upgradable.length; ++i) {
          append({sect: sectionUpgradable, item: upgradable[i]});
        }
        for(var i = 0; i < installed.length; ++i) {
          append({sect: sectionInstalled, item: installed[i]});
        }

        content.currentIndex = Math.min(count - 1, previousIndex);
      }

    }

    Connections {
      target: pndManager
      onDownloadStarted: packages.createModel()
      onDownloadEnqueued: packages.createModel()
      onDownloadError: downloadErrorNotification.show()
      onPackagesChanged: packages.createModel()
    }

    Connections {
      target: search
      onTextChanged: packages.createModel()
    }

    Connections {
      target: view
      onSortByTitleChanged: packages.createModel()
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
        onContentHeightChanged:  y = content.currentItem ? content.currentItem.y : 0
        onCurrentIndexChanged: y = content.currentItem ? content.currentItem.y : 0
      }
    }

    delegate: SectionItem {
      Timer {
        id: downloadStats
        property int prevBytesDownloaded: 0
        property int bytesDownloaded: 0
        interval: 1000
        running: item.isDownloading
        repeat: true
        onTriggered: {
          if(prevBytesDownloaded === 0 && ListView.section === packages.sectionQueued)
          {
            ListView.view.createModel();
          }
          prevBytesDownloaded = bytesDownloaded;
          bytesDownloaded = item.bytesDownloaded;
        }
      }

      function getProgress() {
        if(!item.isDownloading) {
          return "";
        }

        var percentage = Math.floor(100 * item.bytesDownloaded / item.bytesToDownload);
        var t = percentage + "%\n";

        if(downloadStats.prevBytesDownloaded) {
          var rate = downloadStats.bytesDownloaded - downloadStats.prevBytesDownloaded;
          t += Utils.prettySize(rate) + "/s";
        }

        return t;
      }

      width: content.width
      title: item.title ? item.title : item.id
      icon: item.installed ? "image://pnd/" + item.id : item.icon
      progress: getProgress()
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
        } else if(section == packages.sectionQueued) {
          return "Queued"
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
        } else if(section == packages.sectionQueued) {
          return "img/clock_32x32.png"
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
        label: "Rating"
        text: pndUtils.createRatingString(info.pnd)
      }
      PackageInfoText {
        label: "Size"
        text: info.pnd ? Utils.prettySize(info.pnd.size) : "-"
      }
      PackageInfoText {
        label: "Version"
        text: info.pnd ? Utils.versionString(info.pnd.localVersion) : "-"
      }
      PackageInfoText {
        label: "Maintainer"
        text: info.pnd && info.pnd.author.name ? info.pnd.author.name : "-"
      }
      PackageInfoText {
        label: "Location"
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
        text: visible ? Utils.versionString(info.pnd.remoteVersion) : ""
        visible: info.pnd !== null && info.pnd.upgradeCandidate !== null && !info.pnd.isDownloading
      }

      Item {
        width: parent.width
        height: 16
        visible: info.pnd !== null && (info.pnd.isDownloading || info.pnd.isQueued)

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
            onDownloadCancelled: packages.createModel()
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
        visible: info.pnd !== null && info.pnd.isDownloading && !info.pnd.isQueued
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


