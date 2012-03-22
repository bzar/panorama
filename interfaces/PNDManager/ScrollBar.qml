// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
  id: scrollbar
  width: 8
  height: parent.height * parent.height / parent.contentHeight
  anchors.right: parent.right
  y: (parent.height - height) * parent.contentY / (parent.contentHeight - parent.height)
  color: "#666"
  z: 1

  opacity: 0.0

  property bool first: true
  property int prevContentY: 0
  Connections {
    target: parent
    onMovementStarted: scrollbar.show()
    onMovementEnded: scrollbar.hide()
    onCurrentIndexChanged: {
      if(first) {
        first = false;
      } else {
        if(parent.contentY !== prevContentY) {
          prevContentY = parent.contentY;
          scrollbar.show();
          scrollbar.hide();
        }
      }
    }
  }

  function show() {
    if(opacity < 0.01) {
      opacity = 1.0;
    }
  }

  function hide() {
    hideTimer.restart()
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
