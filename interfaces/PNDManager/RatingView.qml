import QtQuick 1.1
import "util.js" as Utils

View {
  viewTitle: "Rating"

  property QtObject pnd: pnd
  property int currentRating: pnd.ownRating

  function rate() {
    if(currentRating > 0) {
      pnd.rate(currentRating);
      spinner.show();
    }
  }

  onOkButton: rate()

  Keys.onLeftPressed: currentRating = currentRating > 1 ? currentRating - 1 : currentRating
  Keys.onRightPressed: currentRating = currentRating < 5 ? currentRating + 1 : currentRating

  Connections {
    target: pnd
    onRateDone: {
      spinner.hide();
      stack.pop();
    }
  }

  Row {
    id: starRow
    anchors.centerIn: parent
    Repeater {
      model: 5
      delegate: Text {
        property int value: index + 1
        property bool isSet: value <= currentRating
        text: "\u2605"
        font.pixelSize: 96
        color: isSet ? "#B5B559" : "#ddd"
        style: Text.Outline
        styleColor: isSet ? "#FFFF40" : "#ccc"


        Behavior on color {
          ColorAnimation { duration: 250 }
        }

        Behavior on styleColor {
          ColorAnimation { duration: 250 }
        }

        MouseArea {
          anchors.fill: parent
          onClicked: currentRating = value
        }
      }
    }
  }

  Button {
    label: "Set rating"
    width: 256
    height: 64
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.margins: 16
    radius: 4
    color: "#B5B559"
    control: "game-b"
    onClicked: rate()
  }
}
