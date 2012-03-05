import Qt 4.7

Item {
  default property alias views: viewContainer.children
  property int currentIndex: views.length - 1
  property QtObject current: views[views.length - 1]
  property QtObject previous: views[views.length > 1 ? views.length - 2 : 0]
  property bool active: false
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
    return next;
  }

  function pop() {
    if(currentIndex > 0) {
      popMoveOut.target = current;
      popMoveOut.start();
      popMoveIn.target = previous;
      popMoveIn.start();
    }
  }

  function getViewTitle() {
    return current.viewTitle
  }

  Item {
    id: viewContainer
    anchors.fill: parent
  }

}
