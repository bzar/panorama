PROJECT(networkmanager-plugin)

FIND_PACKAGE(Qt5Quick REQUIRED)
FIND_PACKAGE(Qt5Qml REQUIRED)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

FIND_PACKAGE(NetworkManagerQt REQUIRED)

SET(networkmanager-plugin_SOURCES
    src/networkmanagerplugin.cpp
    src/networkmanagerproxy.cpp)

SET(networkmanager-plugin_HEADERS
    src/networkmanagerplugin.h
    src/networkmanagerproxy.h)


ADD_DEFINITIONS(${QT_DEFINITIONS} -DQT_PLUGIN -DQT_SHARED)
ADD_LIBRARY(networkmanager MODULE ${networkmanager-plugin_SOURCES} ${networkmanager-plugin_HEADERS_MOC})
TARGET_LINK_LIBRARIES(networkmanager NetworkManagerQt)
qt5_use_modules(networkmanager Quick Qml)
INSTALL(TARGETS networkmanager DESTINATION ${PLUGINDIR}/Panorama/NetworkManager)
