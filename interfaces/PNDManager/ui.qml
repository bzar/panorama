import Qt 4.7
import Panorama.Settings 1.0
import Panorama.UI 1.0
import Panorama.PNDManagement 1.0

PanoramaUI {
  id: ui
  name: "PNDManager"
  description: "PND Manager application"
  author: "B-ZaR"
  anchors.fill: parent

  PNDManager {
    id: pndManager
    Component.onCompleted: { crawl(); sync(); }
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

    Keys.onPressed: {
      if(event.key === Qt.Key_PageDown) {
        next()
      } else if(event.key === Qt.Key_PageUp) {
        prev()
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

      }
    }

    ViewStack {
      id: searchStack
      onActivate: views.activate(searchStack)
      SearchView {

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

    IconButton {
      normalImage: "img/home_32x32.png"
      highlightImage: "img/home_32x32.png"
      highlight: false
      height: parent.height
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
  }
}
