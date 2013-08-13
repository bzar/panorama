import QtQuick 2.0

Item {
  default property alias views: viewContainer.children
  property int currentIndex: 0
  property QtObject current: views[currentIndex]
  property QtObject previous: views[currentIndex ? currentIndex - 1 : currentIndex]
  property bool active: false
  property bool atRootView: currentIndex == 0
  property bool isAnimating: pushMoveIn.running || pushMoveOut.running || popMoveIn.running || popMoveOut.running
  visible: false
  anchors.fill: parent

  signal activate()

  NumberAnimation {
    id: pushMoveIn
    property: "x"
    from: width
    to: 0
    onStopped: target.focus = true;
  }

  NumberAnimation {
    id: pushMoveOut
    property: "x"
    from: 0
    to: -width
    onStopped: target.visible = false
  }

  NumberAnimation {
    id: popMoveIn
    property: "x"
    from: -width
    to: 0
    onStarted: target.visible = true
    onStopped: target.focus = true;
  }

  NumberAnimation {
    id: popMoveOut
    property: "x"
    from: 0
    to: width
    onStopped: target.destroy()
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
    if(currentIndex > 0 && !isAnimating) {
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
