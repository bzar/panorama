import QtQuick 1.1
//import Panorama.Pandora 1.0

View {
  property QtObject pndManager

  viewTitle: "Categories"

  onOkButton: categoryList.openCurrent()

  Keys.forwardTo: categoryList
  ListModel {
    id: categories
    ListElement{ title: "Media"; filter: "Audio|Video|AudioVideo|Graphics" }
    ListElement{ title: "Developer"; filter: "Development" }
    ListElement{ title: "Educational"; filter: "Education" }
    ListElement{ title: "Games"; filter: "Game" }
    ListElement{ title: "Network"; filter: "Network" }
    ListElement{ title: "Office"; filter: "Office" }
    ListElement{ title: "System"; filter: "Settings|System" }
    ListElement{ title: "Utilities"; filter: "Utility" }
  }

  Component { id: categoryView; CategoryView {} }

  Rectangle {
    anchors.fill: parent
    color: "white"

    GridView {
      id: categoryList
      property int columns: 2
      model: categories
      anchors.fill: parent
      boundsBehavior: GridView.StopAtBounds

      function openCurrent() {
        stack.push(categoryView, {"pndManager": pndManager, "categories": currentItem.categoryFilter, "viewTitle": currentItem.categoryTitle});
      }

      cellWidth: width/columns - width%columns
      cellHeight: height/(model.count/columns)

      delegate: Rectangle {
        property string categoryFilter: filter
        property string categoryTitle: title
        width: categoryList.cellWidth
        height: categoryList.cellHeight
        color: Qt.hsla(parseFloat(index)/categoryList.count, 0.5, GridView.isCurrentItem ? 0.7 : 0.5, 1.0)
        border.width: GridView.isCurrentItem ? 2 : 0
        border.color: Qt.hsla(parseFloat(index)/categoryList.count, 0.5, 0.9, 1.0)
        z: GridView.isCurrentItem ? 2 : 1
        scale: GridView.isCurrentItem ? 1.05 : 1.0

        Behavior on scale {
          PropertyAnimation { duration: 100 }
        }

        Text {
          text: title
          font.pixelSize: 32
          anchors.centerIn: parent
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          onEntered: categoryList.currentIndex = index;
          onClicked: {
            categoryList.currentIndex = index;
            categoryList.openCurrent();
          }
        }
      }      
    }
  }
}

