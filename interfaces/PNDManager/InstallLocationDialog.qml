import QtQuick 1.1
import Panorama.PNDManagement 1.0

View {
  viewTitle: "Select install location"
  property QtObject pnd
  property QtObject pndManager

  Rectangle {
    color: "white"
    anchors.fill: parent

    ListView {
      id: device

      property int selected: 0
      property int maxTextWidth: 0

      function selectedItem() {
        return model[selected];
      }

      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: location.top
      anchors.margins: 16
      clip: true
      model: pndManager.devices
      spacing: 4


      delegate: Rectangle {
        property bool selected: index === device.selected
        property bool hover: false

        anchors.horizontalCenter: parent.horizontalCenter
        width: device.maxTextWidth + 32
        height: deviceText.paintedHeight + 16
        radius: 8
        color: selected ? "#555" : hover ? "#ccc" : "transparent"

        Text {
          id: deviceText
          text: modelData.mount
          color: selected ? "white" : "black"
          font.pixelSize: 20
          anchors.centerIn: parent
          Component.onCompleted: device.maxTextWidth = Math.max(paintedWidth, device.maxTextWidth)
        }

        MouseArea {
          id: deviceMouseArea
          anchors.fill: parent
          hoverEnabled: true
          onEntered: parent.hover = true
          onExited: parent.hover = false
          onClicked: device.selected = index
        }
      }
    }
    Row {
      id: location

      property int selected: 0
      property variant options: ["Desktop", "Menu", "Both"]

      function selectedItem() {
        if(options[selected] === "Desktop") {
          return "Desktop";
        } else if(options[selected] === "Menu") {
          return "Menu";
        } else {
          return "DesktopAndMenu";
        }
      }

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: installButton.top
      anchors.margins: 16
      height: childrenRect.height
      spacing: 48

      Repeater {
        model: location.options
        delegate: Rectangle {
          property bool selected: index === location.selected
          property bool hover: false
          width: locationText.paintedWidth + 16
          height: locationText.paintedHeight + 16
          color: selected ? "#555" : hover ? "#ccc" : "transparent"
          radius: 8
          Text {
            anchors.centerIn: parent
            id: locationText
            text: modelData
            color: selected ? "white" : "black"
            font.pixelSize: 16
          }

          MouseArea {
            id: locationMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hover = true
            onExited: parent.hover = false
            onClicked: location.selected = index
          }
        }
      }
    }
    Button {
      id: installButton
      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      width: 256
      height: 64
      anchors.margins: 16
      radius: 4
      label: "Install"
      color: "#69D772"
      onClicked: {
        pnd.install(device.selectedItem(), location.selectedItem());
        stack.pop();
      }
    }
  }
}
