import QtQuick 1.1

Image {
  property string control
  property bool show: true

  source: control ? "img/guihints/p02_" + control + ".png" : ""
  width: 40
  height: 40
  smooth: width != 40 || height != 40
  visible: show && showHints.value
  opacity: 0.93
}
