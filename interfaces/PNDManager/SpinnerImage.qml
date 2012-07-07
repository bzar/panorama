import QtQuick 1.1

Image {
  id: spinnerImage
  source: "img/spin_alt_32x32.png"
  sourceSize {
    height: 64
    width: 64
  }
  smooth: true

  NumberAnimation on rotation {
    running: spinnerImage.visible
    from: 0
    to: 360
    duration: 2000
    loops: NumberAnimation.Infinite
  }
}
