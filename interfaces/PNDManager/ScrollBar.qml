// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
  id: scrollbar
  property QtObject target: parent
  width: 8
  height: target.height * target.height / target.contentHeight
  y: (target.height - height) * target.contentY / (target.contentHeight - target.height)
  color: "#666"
  z: 1

  opacity: 0.0

  function show() {
    hideAnimation.stop();
    opacity = 1.0;
    hideTimer.stop();
  }

  function hide() {
    hideTimer.restart();
  }

  property int prevValue: 0
  function showIfChanged(value) {
    if(value !== prevValue) {
      prevValue = value;
      scrollbar.show();
      scrollbar.hide();
    }
  }

  Timer {
    id: hideTimer
    interval: 1000
    running: false
    repeat: false
    onTriggered: hideAnimation.start()
  }

  NumberAnimation {
    id: hideAnimation
    target: scrollbar
    property: "opacity"
    to: 0.0
    duration: 200
    running: false
    easing.type: Easing.OutQuad
  }
}
