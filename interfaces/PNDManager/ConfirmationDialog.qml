import QtQuick 1.1

Rectangle {
  id: dialog
  property alias message: label.text

  signal yes()
  signal no()

  function show() {
    visible = true;
  }

  visible: false
  onYes: visible = false
  onNo: visible = false

  anchors.fill: parent
  color: Qt.rgba(0.1, 0.1, 0.1, 0.8)


  MouseArea {
    anchors.fill: parent
    onPressed: mouse.accepted = true;
  }

  Rectangle {
    anchors.centerIn: parent
    width: Math.max(label.paintedWidth, 512) + 64
    height: 192
    radius: 16
    color: Qt.rgba(1.0, 1.0, 1.0, 0.9)
    Column {
      anchors.centerIn: parent
      spacing: 16

      Text {
        id: label
        font.pixelSize: 32
        anchors.horizontalCenter: parent.horizontalCenter
      }

      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 16
        Button {
          label: "No"
          control: "game-a"
          color: "#D76D69"
          onClicked: dialog.no()
          width: 256
          height: 64
          radius: 4
        }
        Button {
          label: "Yes"
          color: "#65CF6C"
          control: "game-b"
          onClicked: dialog.yes()
          width: 256
          height: 64
          radius: 4
        }
      }
    }
  }
}
