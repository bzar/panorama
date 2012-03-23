import QtQuick 1.1

View {
  id: view
  property string categories
  property QtObject pndManager
  property QtObject filteredPackages: pndManager.packages.inCategory(categories).notInstalled().sortedByTitle()
  Keys.forwardTo: packageList

  onOkButton: packageList.openCurrent()

  PackageList {
    id: packageList
    columns: 2
    pndManager: view.pndManager
    model: filteredPackages.titleContains(search.text).all()
    anchors.fill: parent

    Keys.priority: Keys.AfterItem
    Keys.forwardTo: [ui, search]
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
      anchors.fill: parent
      anchors.margins: 4
      font.pixelSize: 14
      activeFocusOnPress: false
    }
  }
}

