import QtQuick 1.1

View {
  id: view
  property string categories
  property QtObject pndManager

  Keys.forwardTo: packageList

  onOkButton: packageList.openCurrent()

  PackageList {
    id: packageList
    packages: view.pndManager.packages.inCategory(categories).notInstalled().all()
    pndManager: view.pndManager
  }
}

