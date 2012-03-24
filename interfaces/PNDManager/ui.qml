import QtQuick 1.1
import Panorama.Settings 1.0
import Panorama.UI 1.0
import Panorama.PNDManagement 1.0
import Panorama.Pandora 1.0

PanoramaUI {
  id: ui
  name: "PNDManager"
  description: "PND Manager application"
  author: "B-ZaR"
  anchors.fill: parent

  function init() {
    pndManager.crawl();
  }

  Timer {
     interval: 100
     repeat: false
     running: true
     onTriggered: ui.init()
  }

  PNDManager {
    id: pndManager
    onSyncing: bottomBar.syncing = true
    onSyncDone: {
      bottomBar.syncing = false
      syncCompleteNotification.show()
    }
  }

  Keys.onPressed: {
    if(!Pandora.controlsActive) {
      event.accepted = true;
      if(event.key === Qt.Key_PageDown) {
        views.current.pop();
      } else if(event.key === Qt.Key_End) {
        views.current.current.okButton();
      } else if(event.key === Qt.Key_Home) {
        views.current.current.installRemoveButton();
      } else if(event.key === Qt.Key_PageUp) {
        views.current.current.upgradeButton();
      } else if(event.key === Qt.Key_1) {
        homeStack.activate();
      } else if(event.key === Qt.Key_2) {
        categoriesStack.activate();
      } else if(event.key === Qt.Key_3) {
        installedStack.activate();
      } else if(event.key === Qt.Key_4) {
        searchStack.activate();
      } else {
        event.accepted = false;
      }
    }
  }


  Pandora.onPressed: {
    event.accepted = true;
    if(event.key === Pandora.ButtonX)           views.current.pop();
    else if(event.key === Pandora.ButtonB)      views.current.current.okButton();
    else if(event.key === Pandora.ButtonA)      views.current.current.installRemoveButton();
    else if(event.key === Pandora.ButtonY)      views.current.current.upgradeButton();
    else if(event.key === Pandora.TriggerL)     views.prev();
    else if(event.key === Pandora.TriggerR)     views.next();
    else if(event.key === Pandora.ButtonStart)  bottomBar.reload();
  }


  Notification {
    id: syncCompleteNotification
    text: "Sync complete"
    anchors.centerIn: parent
    z: 2
  }

  TopBar {
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32
    title: views.getViewTitle()
    z: 1
  }

  ViewStackList {
    id: views
    anchors.top: topBar.bottom
    anchors.bottom: bottomBar.top
    anchors.left: parent.left
    anchors.right: parent.right

    ViewStack {
      id: homeStack
      onActivate: views.activate(homeStack)
      HomeView {
        pndManager: pndManager
      }
    }
    ViewStack {
      id: categoriesStack
      onActivate: views.activate(categoriesStack)
      CategoriesView {
        pndManager: pndManager
      }
    }

    ViewStack {
      id: installedStack
      onActivate: views.activate(installedStack)
      InstalledView {
        pndManager: pndManager
      }
    }

    ViewStack {
      id: searchStack
      onActivate: views.activate(searchStack)
      SearchView {
        pndManager: pndManager
      }
    }
  }

  BottomBar {
    id: bottomBar
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 64
    z: 1

    backArrowVisible: !views.current.atRootView

    IconButton {
      normalImage: "img/home_32x32.png"
      highlightImage: "img/home_white_32x32.png"
      highlight: homeStack.active
      height: parent.height
      onClicked: homeStack.activate()
    }
    IconButton {
      normalImage: "img/list_32x28.png"
      highlightImage: "img/list_white_32x28.png"
      highlight: categoriesStack.active
      height: parent.height
      onClicked: categoriesStack.activate()
    }
    IconButton {
      normalImage: "img/download_24x32.png"
      highlightImage: "img/download_white_24x32.png"
      highlight: installedStack.active
      height: parent.height
      onClicked: installedStack.activate()
    }
    IconButton {
      normalImage: "img/magnifying_glass_32x32.png"
      highlightImage: "img/magnifying_glass_white_32x32.png"
      highlight: searchStack.active
      height: parent.height
      onClicked: searchStack.activate()
    }

    onBack: views.current.pop()
    onReload: { pndManager.sync(); }
  }
}
