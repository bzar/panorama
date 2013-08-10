import QtQuick 1.1

Image {
    function accessor(x) {print("not implemented");return null;}
    x: accessor("_x")
    y: accessor("_y")
    source: "../" + accessor("")
}
