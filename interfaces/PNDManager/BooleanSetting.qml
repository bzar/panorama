import QtQuick 1.1
import "theme.js" as Theme

FocusScope {
  property QtObject setting

  function toggle() {
    setting.value = !setting.value;
  }

  Rectangle {
    anchors.fill: parent

    radius: width / 8
    color: setting.value ? Theme.colors.install : "#ccc"
    border.color: setting.value ? Qt.darker(Theme.colors.install) : "#333"
    border.width: width / 32

    Image {
      visible: setting.value
      source: "img/check_32x26.png"
      anchors.centerIn: parent
      fillMode: Image.PreserveAspectFit
    }

    MouseArea {
      anchors.fill: parent
      onClicked: toggle()
    }
  }
}
