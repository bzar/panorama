import QtQuick 1.1
import Panorama.Pandora 1.0

View {
    id: view
    property string categories
    property QtObject pndManager

    Keys.forwardTo: packageList

    Rectangle {
      anchors.fill: parent
      color: "white"
      PackageList {
        id: packageList
        packages: view.pndManager.packages.inCategory(categories).notInstalled().all()
        pndManager: view.pndManager
      }
    }

    Keys.onPressed: {
      if(event.key === Qt.Key_Backspace) {
          stack.pop()
      }
    }

    Pandora.onPressed: {
      event.accepted = true;
      if(event.key === Pandora.ButtonB) packageList.openCurrent();
      else event.accepted = false;
    }

}

