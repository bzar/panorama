// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0

Row {
  property int previousWidth: 0

  function updateLayout() {
    if(previousWidth === width) {
      return;
    }

    previousWidth = width;

    var totalSpacing =  spacing * (children.length -1);
    var itemWidth = (width - totalSpacing) / children.length;

    for(var i = 0; i < children.length; ++i) {
      children[i].width = itemWidth;
    }
  }

  onChildrenChanged: updateLayout()
  onWidthChanged: updateLayout()
}
