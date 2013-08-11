PROJECT(TEXTFILE)

FIND_PACKAGE(Qt5Quick REQUIRED)
FIND_PACKAGE(Qt5Qml REQUIRED)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

SET(textfile_SOURCES
    src/textfileplugin.cpp
    src/textfile.cpp)

SET(textfile_HEADERS
    src/textfileplugin.h
    src/textfile.h)

ADD_DEFINITIONS(${QT_DEFINITIONS} -DQT_PLUGIN -DQT_SHARED)
ADD_LIBRARY(textfile MODULE ${textfile_SOURCES})
qt5_use_modules(textfile Quick Qml)

INSTALL(TARGETS textfile DESTINATION ${PLUGINDIR}/Panorama/TextFile)
