// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
  id: overlay
  color: "#111"
  opacity: 0.3
  property int n: 0
  visible: n > 0

  function show() {
    n += 1;
  }

  function hide() {
    n -= 1;
  }

  Image {
    anchors.centerIn: parent
    source: "img/spin_alt_32x32.png"
    sourceSize {
      height: 64
      width: 64
    }
    smooth: true

    NumberAnimation on rotation {
      running: overlay.visible
      from: 0
      to: 360
      duration: 2000
      loops: NumberAnimation.Infinite
    }
  }

  MouseArea {
    anchors.fill: parent
    onPressed: { return true; }
  }
}
