PROJECT(networkmanager-plugin)

FIND_PACKAGE(Qt4 REQUIRED)
FIND_PACKAGE(NetworkManagerQt REQUIRED)
SET(QT_USE_QTDECLARATIVE TRUE)

SET(networkmanager-plugin_SOURCES
    src/networkmanagerplugin.cpp
    src/networkmanagerproxy.cpp)

SET(networkmanager-plugin_HEADERS
    src/networkmanagerplugin.h
    src/networkmanagerproxy.h)

QT4_WRAP_CPP(networkmanager-plugin_HEADERS_MOC ${networkmanager-plugin_HEADERS})

INCLUDE(${QT_USE_FILE})
ADD_DEFINITIONS(${QT_DEFINITIONS} -DQT_PLUGIN -DQT_SHARED)
ADD_LIBRARY(networkmanager MODULE ${networkmanager-plugin_SOURCES} ${networkmanager-plugin_HEADERS_MOC})
TARGET_LINK_LIBRARIES(networkmanager NetworkManagerQt)
INSTALL(TARGETS networkmanager DESTINATION ${PLUGINDIR}/Panorama/NetworkManager)
