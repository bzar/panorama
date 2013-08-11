// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0

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
    if(n > 0)
      n -= 1;
  }

  SpinnerImage {
    id: spinnerImage
    anchors.centerIn: parent
  }

  MouseArea {
    anchors.fill: parent
    onPressed: { return true; }
  }
}
