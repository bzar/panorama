import Qt 4.7

Item {
  default property alias viewStacks: viewStackContainer.children
  property int currentIndex: 0
  property QtObject current: viewStacks[currentIndex]

  function updateVisibility() {
    for(var i = 0; i < viewStacks.length; ++i) {
      viewStacks[i].visible = i === currentIndex;
    }
  }

  function show(index) {
    currentIndex = index;
    updateVisibility();
    viewStacks[index].current.focus = true;
  }

  function next() {
    show((currentIndex + 1) % viewStacks.length);
  }

  function prev() {
    show((viewStacks.length + currentIndex - 1) % viewStacks.length);
  }

  Component.onCompleted: show(0)

  Item {
    id: viewStackContainer
    anchors.fill: parent
  }
}
