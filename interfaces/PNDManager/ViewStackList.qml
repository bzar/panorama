import QtQuick 1.1

Item {
  default property alias viewStacks: viewStackContainer.children
  property int fromIndex: 0
  property int currentIndex: 0
  property QtObject current: viewStacks[currentIndex]

  function getViewTitle() {
    return current.getViewTitle();
  }

  function updateVisibility() {
    for(var i = 0; i < viewStacks.length; ++i) {
      viewStacks[i].visible = i === currentIndex;
    }
  }

  function show(index) {
    fromIndex = currentIndex;
    current.active = false
    current.current.focus = false;
    currentIndex = index;
    updateVisibility();
    viewStacks[index].current.focus = true;
    viewStacks[index].active = true
  }

  function activate(child) {
    for(var i = 0; i < viewStacks.length; ++i) {
      if(viewStacks[i] === child) {
        show(i);
        break;
      }
    }
  }

  function next() {
    show((currentIndex + 1) % viewStacks.length);
  }

  function prev() {
    show((viewStacks.length + currentIndex - 1) % viewStacks.length);
  }

  function undo() {
    show(fromIndex);
  }

  Component.onCompleted: show(currentIndex)

  Item {
    id: viewStackContainer
    anchors.fill: parent
  }
}
