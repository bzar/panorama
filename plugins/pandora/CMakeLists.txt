PROJECT(PANDORA)

FIND_PACKAGE(Qt5Quick REQUIRED)
FIND_PACKAGE(Qt5Qml REQUIRED)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

SET(pandora_SOURCES
    src/pandoraplugin.cpp
    src/pandoraeventsource.cpp
    src/pandora.cpp
    src/pandoraattached.cpp
    src/pandoraeventlistener.cpp
    src/pandorakeyevent.cpp)

SET(pandora_HEADERS
    src/pandoraplugin.h
    src/pandoraeventsource.h
    src/pandora.h
    src/pandoraattached.h
    src/pandoraeventlistener.h
    src/pandorakeyevent.h)

INCLUDE_DIRECTORIES(${PND_BINARY_DIR}/include/)

ADD_DEFINITIONS(${QT_DEFINITIONS} -DQT_PLUGIN -DQT_SHARED)
ADD_LIBRARY(pandora MODULE ${pandora_SOURCES})
TARGET_LINK_LIBRARIES(pandora pnd)
qt5_use_modules(pandora Quick Qml)

INSTALL(TARGETS pandora DESTINATION ${PLUGINDIR}/Panorama/Pandora)

