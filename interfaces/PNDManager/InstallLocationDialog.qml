import QtQuick 1.1
import "theme.js" as Theme
import "util.js" as Utils

View {
  viewTitle: "Select install location"
  property QtObject pnd
  property QtObject pndManager

  onOkButton: install()
  Keys.forwardTo: [deviceList, location]

  function install() {
    if(pnd.size <= deviceList.currentItem.device.free)
    {
      installButton.enabled = false;
      spinner.show();
      lastInstallDevice.value = deviceList.currentItem.device.mount;
      lastInstallLocation.value = location.options[location.selected];
      pnd.install(deviceList.currentItem.device, location.selectedItem());
    }
  }

  Notification {
    id: downloadErrorNotification
    text: "Error downloading PND!"
    anchors.centerIn: parent
    z: 2
  }

  Connections {
    target: pnd
    onDownloadStarted: {
      stack.pop();
    }
    onDownloadEnqueued: {
      stack.pop();
    }
    onDownloadError: {
      downloadErrorNotification.show();
      spinner.hide();
      installButton.enabled = true;
    }
  }

  Component.onCompleted: {
    if(lastInstallDevice.value) {
      for(var i = 0; i < deviceList.model.length; ++i) {
        if(deviceList.model[i].mount === lastInstallDevice.value) {
          deviceList.currentIndex = i;
          break;
        }
      }
    }

    if(lastInstallLocation.value) {
      for(var i = 0; i < location.options.length; ++i) {
        if(location.options[i] === lastInstallLocation.value) {
          location.selected = i;
          break;
        }
      }
    }
  }

  StyledListView {
    id: deviceList

    property int maxTextWidth: 0

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: location.top
    width: maxTextWidth + 64
    anchors.margins: 16
    clip: true
    model: pndManager.devices
    spacing: 4
    highlightFollowsCurrentItem: false

    highlight : Rectangle {
      color: "#555"
      radius: 8
      anchors.horizontalCenter: parent.horizontalCenter
      width: deviceList.maxTextWidth + 16
      height: deviceList.currentItem.height
      y: deviceList.currentItem.y
    }

    delegate: Rectangle {
      property bool selected: index === deviceList.currentIndex
      property bool hover: false
      property QtObject device: modelData

      anchors.horizontalCenter: parent.horizontalCenter
      width: deviceList.maxTextWidth + 32
      height: textContainer.height + 16
      radius: 8
      color: hover ? "#ccc" : "transparent"

      Item {
        id: textContainer
        anchors.centerIn: parent
        width: Math.max(deviceText.paintedWidth, freeSpaceText.paintedWidth)
        height: childrenRect.height
        Component.onCompleted: deviceList.maxTextWidth = Math.max(width, deviceList.maxTextWidth)
        Text {
          id: deviceText
          text: mount
          color: selected ? "white" : "black"
          font.pixelSize: 20
          anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
          id: freeSpaceText
          text: Utils.prettySize(free) + " available"
          color: selected ? "white" : "black"
          font.pixelSize: 12
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: deviceText.bottom
        }
      }


      MouseArea {
        id: deviceMouseArea
        anchors.fill: parent
        onClicked: deviceList.currentIndex = index
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

    Keys.onLeftPressed: selected = Math.max(0, selected - 1)
    Keys.onRightPressed: selected = Math.min(options.length - 1, selected + 1)

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
    enabled: pnd.size <= deviceList.currentItem.device.free
    label: "Install"
    sublabel: "Requires " + Utils.prettySize(pnd.size)
    color: Theme.colors.install
    control: "game-b"
    onClicked: install()
  }
}
