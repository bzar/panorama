import QtQuick 1.1
import "util.js" as Utils

View {
  viewTitle: "Rating"

  property QtObject pnd: pnd
  property int currentRating: pnd.ownRating
  property int lastRating: pnd.ownRating

  function rate() {
    if(currentRating > 0) {
      pnd.rate(currentRating);
      spinner.show();
    }
  }

  onOkButton: rate()

  Keys.onLeftPressed: currentRating = currentRating > 1 ? currentRating - 1 : currentRating
  Keys.onRightPressed: currentRating = currentRating < 5 ? currentRating + 1 : currentRating

  Keys.onPressed: {
    event.accepted = true;
    if(event.key === Qt.Key_1) {
      currentRating = 1;
    } else if(event.key === Qt.Key_2) {
      currentRating = 2;
    } else if(event.key === Qt.Key_3) {
      currentRating = 3;
    } else if(event.key === Qt.Key_4) {
      currentRating = 4;
    } else if(event.key === Qt.Key_5) {
      currentRating = 5;
    } else {
      event.accepted = false;
    }
  }

  Notification {
    id: rateErrorNotification
    text: "Error adding rating!"
    anchors.centerIn: parent
    z: 2
  }

  Connections {
    target: pnd
    onRateDone: {
      spinner.hide();
      stack.pop();
    }

    onRateFail: {
      spinner.hide();
      currentRating = lastRating;
      rateErrorNotification.show();
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
    control: okButtonGuiHintControl
    onClicked: rate()
  }
}
