PROJECT(pndmanagement)

FIND_PACKAGE(Qt4 REQUIRED)
SET(QT_USE_QTDECLARATIVE TRUE)

file(GLOB_RECURSE pndmanagement_SOURCES src/*.cpp)
file(GLOB_RECURSE pndmanagement_HEADERS src/*.h)

QT4_WRAP_CPP(pndmanagement_HEADERS_MOC ${pndmanagement_HEADERS})
INCLUDE(${QT_USE_FILE})
ADD_DEFINITIONS(${QT_DEFINITIONS} -DQT_PLUGIN -DQT_SHARED)

INCLUDE_DIRECTORIES(${qtpndman_SOURCE_DIR}/include/ ${libpndman_SOURCE_DIR}/include/ ${PND_BINARY_DIR}/include/)

ADD_LIBRARY(pndmanagement MODULE ${pndmanagement_SOURCES} ${pndmanagement_HEADERS_MOC})
TARGET_LINK_LIBRARIES(pndmanagement qtpndman pnd)
INSTALL(TARGETS pndmanagement DESTINATION ${PLUGINDIR}/Panorama/PNDManagement)

