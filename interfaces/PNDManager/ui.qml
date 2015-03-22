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

  Setting {
    id: showSplashScreen
    defaultValue: true
    key: "showSplashScreen"
    section: "PNDManager"
    Component.onCompleted: splashScreen.visible = value
  }

  Setting {
    id: showHints
    defaultValue: true
    key: "showHints"
    section: "PNDManager"
  }

  Setting {
      id: mouseCursorVisible
      section: "PNDManager"
      key: "mouseCursorVisible"
      defaultValue: false
      onValueChanged: runtime.mouseCursorVisible = value
      Component.onCompleted: runtime.mouseCursorVisible = value
  }


  Setting {
      id: lastInstallDevice
      section: "PNDManager"
      key: "lastInstallDevice"
      defaultValue: ""
  }

  Setting {
      id: lastInstallLocation
      section: "PNDManager"
      key: "lastInstallLocation"
      defaultValue: ""
  }

  Setting {
      id: loggingVerbosity
      section: "PNDManager"
      key: "loggingVerbosity"
      defaultValue: 5
      onValueChanged: pndManager.verbosity = value
      Component.onCompleted: pndManager.verbosity = value
  }

  Setting {
      id: maxDownloads
      section: "PNDManager"
      key: "maxDownloads"
      defaultValue: 4
      onValueChanged: pndManager.maxDownloads = value
      Component.onCompleted: pndManager.maxDownloads = value
  }

  Setting {
    id: usernameSetting
    section: "PNDManager"
    key: "username"
    defaultValue: ""
  }

  Setting {
    id: apiKeySetting
    section: "PNDManager"
    key: "apiKey"
    defaultValue: ""
  }

  Setting {
    id: customDevices
    section: "PNDManager"
    key: "customDevices"
    defaultValue: ""
    Component.onCompleted: pndManager.addCustomDevicesString(value)
  }

  Setting {
    id: flipBX
    section: "PNDManager"
    key: "flipBX"
    defaultValue: false
  }

  property string okButtonGuiHintControl: flipBX.value ? "game-x" : "game-b"

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
    onSyncError: {
      bottomBar.syncing = false
      bottomBar.syncError = true
      syncFailedNotification.show()
    }

    username: usernameSetting.value
    key: apiKeySetting.value
  }

  property bool loggedIn: pndManager.username && pndManager.key
  
  PNDUtils { id: pndUtils }

  signal buttonA;
  signal buttonB;
  signal buttonX;
  signal buttonY;
  signal buttonL;
  signal buttonR;
  signal button1;
  signal button2;
  signal button3;
  signal button4;
  signal buttonStart;
  signal buttonSelect;
  signal buttonF1;
  signal buttonF9;
  signal buttonF10;
  signal buttonEsc;

  onButtonA: {
    if(splashScreen.visible) {
      splashScreen.dontShowAgain();
    } else {
      views.current.current.removeButton();
    }
  }

  onButtonB: {
    if(splashScreen.visible) {
      splashScreen.hide();
    } else {
      views.current.current.okButton();
    }
  }

  onButtonX: views.current.pop()
  onButtonY: views.current.current.installUpgradeButton()
  onButtonL: views.prev()
  onButtonR: views.next()
  onButtonStart: bottomBar.reload()
  onButtonSelect: views.current.current.selectButton()
  onButton1: installedStack.activate()
  onButton2: homeStack.activate()
  onButton3: categoriesStack.activate()
  onButton4: searchStack.activate()
  onButtonF1: showHints.value = !showHints.value
  onButtonF9: topBar.settingsButtonClicked()
  onButtonF10: runtime.quit()
  onButtonEsc: runtime.quit()

  Keys.onPressed: {
    if(!runtime.isActiveWindow || pndManager.applicationRunning) {
      event.accepted = true;
      return
    }

    if(!Pandora.controlsActive && !spinner.visible) {
      event.accepted = true;
      if(event.key === Qt.Key_PageDown) {
        flipBX.value ? buttonB() : buttonX();
      } else if(event.key === Qt.Key_End) {
        flipBX.value ? buttonX() : buttonB();
      } else if(event.key === Qt.Key_Home) {
        buttonA();
      } else if(event.key === Qt.Key_PageUp) {
        buttonY();
      } else if(event.key === Qt.Key_Insert) {
        buttonL();
      } else if(event.key === Qt.Key_Delete) {
        buttonR();
      } else if(event.key === Qt.Key_1) {
        button1();
      } else if(event.key === Qt.Key_2) {
        button2();
      } else if(event.key === Qt.Key_3) {
        button3();
      } else if(event.key === Qt.Key_4) {
        button4();
      } else {
        event.accepted = false;
      }
    }

    if(event.key === Qt.Key_F1) {
      buttonF1();
      event.accepted = true;
    } else if(event.key === Qt.Key_F9) {
      buttonF9();
      event.accepted = true;
    } else if(event.key === Qt.Key_F10) {
      buttonF10();
      event.accepted = true;
    } else if(event.key === Qt.Key_Escape) {
      buttonEsc();
    }
  }

  Pandora.onPressed: {
    if(spinner.visible || !runtime.isActiveWindow || pndManager.applicationRunning) {
      event.accepted = true;
      return
    }

    event.accepted = true;
    if(event.key === Pandora.ButtonX) {
      flipBX.value ? buttonB() : buttonX();
    } else if(event.key === Pandora.ButtonB) {
      flipBX.value ? buttonX() : buttonB();
    } else if(event.key === Pandora.ButtonA) {
      buttonA();
    } else if(event.key === Pandora.ButtonY) {
      buttonY();
    } else if(event.key === Pandora.TriggerL) {
      buttonL();
    } else if(event.key === Pandora.TriggerR) {
      buttonR();
    } else if(event.key === Pandora.ButtonStart) {
      buttonStart();
    } else if(event.key === Pandora.ButtonSelect) {
      buttonSelect();
    }
  }


  Notification {
    id: syncCompleteNotification
    text: "Sync complete"
    anchors.centerIn: parent
    z: 2
  }

  Notification {
    id: syncFailedNotification
    text: "Sync failed"
    anchors.centerIn: parent
    z: 2
  }

  Notification {
    id: syncingNotification
    text: "Syncing"
    anchors.centerIn: parent
    z: 2
  }

  SpinnerOverlay {
    id: spinner
    anchors.fill: parent
    z: 3
  }

  HelpDialog {
    id: splashScreen
    anchors.fill: parent
    z: 2
    visible: false
    onHide: visible = false
    onDontShowAgain: showSplashScreen.value = false
  }

  TopBar {
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32
    title: views.getViewTitle()
    z: 1
    showCloseButton: fullscreen.value
    showSettingsButton: !settingsStack.active
    onCloseButtonClicked: runtime.quit()
    onSettingsButtonClicked: settingsStack.active ? views.undo() : settingsStack.activate()
  }

  ViewStackList {
    id: views
    currentIndex: 1
    anchors.top: topBar.bottom
    anchors.bottom: bottomBar.top
    anchors.left: parent.left
    anchors.right: parent.right

    ViewStack {
      id: installedStack
      onActivate: views.activate(installedStack)
      InstalledView {
        pndManager: pndManager
      }
    }

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
      id: searchStack
      onActivate: views.activate(searchStack)
      SearchView {
        pndManager: pndManager
      }
    }

    ViewStack {
      id: settingsStack
      onActivate: views.activate(settingsStack)
      SettingsView {
        onExit: views.undo()
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

    enabled: !settingsStack.active
    backArrowVisible: !views.current.atRootView

    IconButton {
      id: installedIcon
      rightHintVisible: searchIcon.highlight
      leftHintVisible: homeIcon.highlight
      normalImage: "img/bottombar/pndme-0.6.1.0-cat-installed-flimsy.png"
      highlightImage: "img/bottombar/pndme-0.6.1.0-cat-installed-flimsy_active.png"
      highlight: installedStack.active
      height: parent.height
      onClicked: installedStack.activate()
    }
    IconButton {
      id: homeIcon
      rightHintVisible: installedIcon.highlight
      leftHintVisible: categoriesIcon.highlight
      normalImage: "img/bottombar/pndme-0.6.1.0-cat-home-flimsy.png"
      highlightImage: "img/bottombar/pndme-0.6.1.0-cat-home-flimsy_active.png"
      highlight: homeStack.active
      height: parent.height
      onClicked: homeStack.activate()
    }
    IconButton {
      id: categoriesIcon
      rightHintVisible: homeIcon.highlight
      leftHintVisible: searchIcon.highlight
      normalImage: "img/bottombar/pndme-0.6.1.0-cat-online-flimsy.png"
      highlightImage: "img/bottombar/pndme-0.6.1.0-cat-online-flimsy_active.png"
      highlight: categoriesStack.active
      height: parent.height
      onClicked: categoriesStack.activate()
    }
    IconButton {
      id: searchIcon
      rightHintVisible: categoriesIcon.highlight
      leftHintVisible: installedIcon.highlight
      normalImage: "img/bottombar/pndme-0.6.1.0-cat-search-flimsy.png"
      highlightImage: "img/bottombar/pndme-0.6.1.0-cat-search-flimsy_active.png"
      highlight: searchStack.active
      height: parent.height
      onClicked: searchStack.activate()
    }

    onBack: views.current.pop()
    onReload: {
      syncError = false;
      if(!bottomBar.syncing) {
         syncingNotification.show()
         pndManager.sync();
      }
    }
  }
}
