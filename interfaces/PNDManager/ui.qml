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
    Component.onCompleted: { crawl(); }
  }

  ViewStackList {
    id: views
    anchors.fill: parent

    Keys.onPressed: {
      if(event.key === Qt.Key_PageDown) {
        next()
      } else if(event.key === Qt.Key_PageUp) {
        prev()
      }
    }

    ViewStack {
      CategoriesView {
        pndManager: pndManager
      }
    }

    ViewStack {
      InstalledView {

      }
    }

    ViewStack {
      SearchView {

      }
    }
  }
}
