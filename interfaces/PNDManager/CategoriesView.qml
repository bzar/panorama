import QtQuick 1.1

View {
  property QtObject pndManager

  viewTitle: "Categories"

  onOkButton: categoryList.openCurrent()

  Keys.forwardTo: categoryList
  ListModel {
    id: categories
    ListElement{ title: "Media"; filter: "Audio|Video|AudioVideo"; icon: "img/category_media.png" }
    ListElement{ title: "Graphics"; filter: "Graphics"; icon: "img/category_graphics.png" }
    ListElement{ title: "Developer"; filter: "Development"; icon: "img/category_development.png" }
    ListElement{ title: "Educational"; filter: "Education"; icon: "img/category_educational.png" }
    ListElement{ title: "Games"; filter: "Game"; icon: "img/category_games.png" }
    ListElement{ title: "Network"; filter: "Network"; icon: "img/category_network.png" }
    ListElement{ title: "Office"; filter: "Office"; icon: "img/category_office.png" }
    ListElement{ title: "System"; filter: "Settings|System"; icon: "img/category_system.png" }
    ListElement{ title: "Utilities"; filter: "Utility"; icon: "img/category_utilities.png" }
    ListElement{ title: "Other"; filter: "(?!Audio|Video|AudioVideo|Graphics|Development|Education|Game|Network|Office|Settings|System|Utility).*"; icon: "img/category_other.png" }
  }

  Component { id: categoryView; CategoryView {} }

  GridView {
    id: categoryList
    property int columns: 2
    property int rows: model.count / columns
    model: categories
    anchors.centerIn: parent
    width: Math.floor(parent.width/columns) * columns
    height: Math.floor(parent.height/rows) * rows

    boundsBehavior: GridView.StopAtBounds

    function openCurrent() {
      stack.push(categoryView, {"pndManager": pndManager, "categories": currentItem.categoryFilter, "viewTitle": currentItem.categoryTitle});
    }

    cellWidth: width/columns
    cellHeight: height/rows
    highlight: Rectangle {
      width: categoryList.cellWidth
      height: categoryList.cellHeight
      color: "#ddd"
      radius: 8
      x: categoryList.currentItem.x
      y: categoryList.currentItem.y

      GuiHint {
        control: okButtonGuiHintControl
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 4
      }
    }

    highlightFollowsCurrentItem: false
    delegate: Item {
      property string categoryFilter: filter
      property string categoryTitle: title
      property bool selected: index === categoryList.currentIndex
      width: categoryList.cellWidth
      height: categoryList.cellHeight

      Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 32
        width: childrenRect.width
        height: childrenRect.height
        Image {
          id: iconImage
          source: icon
          asynchronous: true
          height: 32
          width: 32
          fillMode: Image.PreserveAspectFit
          sourceSize {
            height: 32
            width: 32
          }
        }

        Text {
          text: title
          height: 32
          verticalAlignment: Text.AlignVCenter
          font.pixelSize: 32
          anchors.left: iconImage.right
          anchors.margins: 32
        }
      }

      MouseArea {
        anchors.fill: parent
        onPressed: {
          categoryList.currentIndex = index;
          categoryList.openCurrent();
        }
      }

      Rectangle {
        height: 1
        color: selected ? "transparent" : "#eee"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 16
        anchors.rightMargin: 16
      }
    }
  }
}

