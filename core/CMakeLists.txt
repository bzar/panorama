FIND_PACKAGE(Qt5Gui REQUIRED)
FIND_PACKAGE(Qt5Quick REQUIRED)
FIND_PACKAGE(Qt5Qml REQUIRED)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

SET(panorama_SOURCES
    src/main.cpp
    src/mainwindow.cpp
    src/runtime.cpp)

SET(panorama_HEADERS
    src/mainwindow.h
    src/runtime.h)

SET(panorama_RESOURCES
    qrc/default.qrc)

qt5_add_resources (panorama_SOURCES ${panorama_RESOURCES})

ADD_EXECUTABLE(panorama ${panorama_SOURCES})
qt5_use_modules(panorama Gui Quick Qml)

IF(PANDORA)
    INSTALL(TARGETS panorama DESTINATION .)
ELSE(PANDORA)
    INSTALL(TARGETS panorama DESTINATION bin)
ENDIF(PANDORA)
