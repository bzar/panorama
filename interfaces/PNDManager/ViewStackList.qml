import Qt 4.7

Item {
  default property alias viewStacks: viewStackContainer.children
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
    current.active = false
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
    show((viewStacks.length + currentIndex - 1) % viewStacks.length);
  }

  function prev() {
    show((currentIndex + 1) % viewStacks.length);
  }

  Component.onCompleted: show(0)

  Item {
    id: viewStackContainer
    anchors.fill: parent
  }
}
