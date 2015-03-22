import QtQuick 1.1
import "theme.js" as Theme

FocusScope {
  id: scope
  property QtObject setting
  property bool swap: false
  property string enabledText: "On"
  property string disabledText: "Off"
  signal toggled(bool value)

  height: childrenRect.height

  function toggle(value) {
    setting.value = value === undefined ? !setting.value : value;
    toggled(setting.value)
  }

  function toggleIfActive() {
    if(activeFocus) {
      toggle();
    }
  }

  Text {
    id: enabled
    text: enabledText
    anchors.left: swap ? parent.horizontalCenter : parent.left
    anchors.right: swap ? parent.right : parent.horizontalCenter
    anchors.rightMargin: swap ? 18 : 16
    anchors.leftMargin: swap ? 16 : 0
    font.pixelSize: 20
    font.letterSpacing: 2
    color: setting.value ? "#fff" : "#999"
    opacity: setting.value ? 1.0 : 0.8
    MouseArea {
      anchors.fill: parent
      onPressed: toggle(true)
    }
    Rectangle {
      anchors.fill: parent
      anchors.leftMargin: -8
      anchors.rightMargin: -8
      anchors.topMargin: -4
      anchors.bottomMargin: -4
      color: Qt.rgba(0, 0, 0, scope.activeFocus ? 0.4 : 0.1)
      radius: height / 8
      visible: setting.value
      z: -1
    }
  }
  Text {
    id: disabled
    text: disabledText
    anchors.left: swap ? parent.left : parent.horizontalCenter
    anchors.right: swap ? parent.horizontalCenter : parent.right
    anchors.leftMargin: swap ? 0 : 16
    anchors.rightMargin: swap ? 16 : 18
    font.pixelSize: 20
    font.letterSpacing: 2
    color: !setting.value ? "#fff" : "#999"
    opacity: !setting.value ? 1.0 : 0.8
    MouseArea {
      anchors.fill: parent
      onPressed: toggle(false)
    }
    Rectangle {
      anchors.fill: parent
      anchors.leftMargin: -8
      anchors.rightMargin: -8
      anchors.topMargin: -4
      anchors.bottomMargin: -4
      color: Qt.rgba(0.2, 0.2, 0.2, scope.activeFocus ? 0.7 : 0.2)
      radius: height / 8
      visible: !setting.value
      z: -1
    }
  }

}
