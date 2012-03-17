import QtQuick 1.1
//import Panorama.Pandora 1.0

View {
  id: view
  property string categories
  property QtObject pndManager

  Keys.forwardTo: packageList

  onOkButton: packageList.openCurrent()

  Rectangle {
    anchors.fill: parent
    color: "white"
    PackageList {
      id: packageList
      packages: view.pndManager.packages.inCategory(categories).notInstalled().all()
      pndManager: view.pndManager
    }
  }
}

