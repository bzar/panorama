import QtQuick 1.1

Item {
  default property alias views: viewContainer.children
  property int currentIndex: 0
  property QtObject current: views[currentIndex]
  property QtObject previous: views[currentIndex ? currentIndex - 1 : currentIndex]
  property bool active: false
  property bool atRootView: currentIndex == 0
  visible: false
  anchors.fill: parent

  signal activate()

  NumberAnimation {
    id: pushMoveIn
    property: "x"
    from: width
    to: 0
    onCompleted: target.focus = true;
  }

  NumberAnimation {
    id: pushMoveOut
    property: "x"
    from: 0
    to: -width
    onCompleted: target.visible = false
  }

  NumberAnimation {
    id: popMoveIn
    property: "x"
    from: -width
    to: 0
    onStarted: target.visible = true
    onCompleted: target.focus = true;
  }

  NumberAnimation {
    id: popMoveOut
    property: "x"
    from: 0
    to: width
    onCompleted: target.destroy()
  }

  function push(viewComponent, properties) {
    pushMoveOut.target = current;
    pushMoveOut.start();
    var next = viewComponent.createObject(viewContainer, properties);
    pushMoveIn.target = next;
    pushMoveIn.start();
    currentIndex += 1;
    return next;
  }

  function pop() {
    if(currentIndex > 0) {
      popMoveOut.target = current;
      popMoveOut.start();
      popMoveIn.target = previous;
      popMoveIn.start();
      currentIndex -= 1;
    }
  }

  function getViewTitle() {
    if(atRootView)
      return current.viewTitle
    else
      return previous.viewTitle + " > " + current.viewTitle
  }

  Item {
    id: viewContainer
    anchors.fill: parent
  }

}
