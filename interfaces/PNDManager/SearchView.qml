import QtQuick 1.1

View {
  id: view
  viewTitle: "Search"

  property QtObject pndManager

  Keys.forwardTo: packageList
  onOkButton: packageList.openCurrent()

  Rectangle {
    id: searchContainer
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: 64
    color: "#eee"
    z: 1

    Rectangle {
      id: searchBox
      color: "#fff"
      border.color:  "#ccc"
      border.width: 1
      radius: 8
      height: 32
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 16

      Image {
        id: searchIcon
        source: "img/magnifying_glass_32x32.png"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 4
        fillMode: Image.PreserveAspectFit
        smooth: true
      }

      TextInput {
        id: search
        anchors.left: searchIcon.right
        anchors.right: searchHint.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 4
        font.pixelSize: 20
        activeFocusOnPress: false
        cursorVisible: true
        Keys.onRightPressed: event.accepted = true
        Keys.onLeftPressed: event.accepted = true
        onAccepted: {
          if(text) {
            packageList.model = pndManager.searchPackages(text).sortedByTitle().all();
            noSearchResultsText.visible = packageList.count === 0;
          } else {
            packageList.model = null;
          }
        }
      }

      GuiHint {
        id: searchHint
        control: "keyboard-enter"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: height
      }
    }

    Rectangle {
      height: 1
      color: "#ccc"
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
    }

  }

  PackageList {
    id: packageList
    pndManager: view.pndManager
    anchors.top: searchContainer.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 8
    columns: 2
    model: null
    Keys.priority: Keys.AfterItem
    Keys.forwardTo: [ui, search]

    delegate: PackageDelegate {
      pnd: modelData
      height: packageList.cellHeight
      width: packageList.cellWidth

      onClicked: {
        packageList.currentIndex = index;
        packageList.openCurrent();
      }

      Text {
        id: categoriesText
        text: pndUtils.createCategoryString(modelData) + "\n" + modelData.author.name
        font.pixelSize: 14
      }

      Text {
        function getRating() {
          var s = "";
          for(var i = 0; i < Math.ceil(pnd.rating/20); ++i) {
            s += "★";
          }
          return s;
        }

        text: getRating()
        visible: pnd.rating !== 0
        font.pixelSize: 14

        anchors.top: categoriesText.bottom
        anchors.right: parent.right
        anchors.rightMargin: 32
      }

      Image {
        source: "img/download_darkgrey_24x32.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8
        height: 16
        width: 16
        fillMode: Image.PreserveAspectFit
        visible: modelData.installed
      }
    }

    Text {
      id: noSearchResultsText
      text: "No search results"
      font.pixelSize: 20
      anchors.centerIn: parent
      visible: false
    }

  }

}

