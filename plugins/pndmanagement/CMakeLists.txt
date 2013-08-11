PROJECT(pndmanagement)

FIND_PACKAGE(Qt5Quick REQUIRED)
FIND_PACKAGE(Qt5Qml REQUIRED)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

file(GLOB_RECURSE pndmanagement_SOURCES src/*.cpp)
file(GLOB_RECURSE pndmanagement_HEADERS src/*.h)
INCLUDE_DIRECTORIES(${qtpndman_SOURCE_DIR}/include/ ${libpndman_SOURCE_DIR}/include/ ${PND_SOURCE_DIR}/src/include/)

ADD_LIBRARY(pndmanagement MODULE ${pndmanagement_SOURCES})
TARGET_LINK_LIBRARIES(pndmanagement qtpndman pnd)
qt5_use_modules(pndmanagement Quick Qml)

INSTALL(TARGETS pndmanagement DESTINATION ${PLUGINDIR}/Panorama/PNDManagement)

