PROJECT(SYSTEMINFORMATION)

FIND_PACKAGE(Qt5Quick REQUIRED)
FIND_PACKAGE(Qt5Qml REQUIRED)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

SET(systeminformation_SOURCES
    src/systeminformationplugin.cpp
    src/systeminformation.cpp
    src/systeminformationattached.cpp)

SET(systeminformation_HEADERS
    src/systeminformationplugin.h
    src/systeminformation.h
    src/systeminformationattached.h)

ADD_DEFINITIONS(${QT_DEFINITIONS} -DQT_PLUGIN -DQT_SHARED)
ADD_LIBRARY(systeminformation MODULE ${systeminformation_SOURCES})
qt5_use_modules(systeminformation Quick Qml)
INSTALL(TARGETS systeminformation DESTINATION ${PLUGINDIR}/Panorama/SystemInformation)

