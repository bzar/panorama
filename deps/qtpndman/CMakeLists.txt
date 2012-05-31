PROJECT(QTPNDMAN)

FIND_PACKAGE(Qt4 REQUIRED)

file (GLOB_RECURSE qtpndman_SOURCES src/src/*.cpp)
file (GLOB_RECURSE qtpndman_HEADERS src/include/*.h)
file (GLOB_RECURSE qtpndman_INCLUDES src/include/*.h)

INCLUDE_DIRECTORIES(src/include/)
INCLUDE_DIRECTORIES(${PNDMAN_BINARY_DIR}/include/)

QT4_WRAP_CPP(qtpndman_HEADERS_MOC ${qtpndman_HEADERS})
INCLUDE(${QT_USE_FILE})
ADD_DEFINITIONS(${QT_DEFINITIONS})

FILE(COPY ${qtpndman_INCLUDES} DESTINATION include)
ADD_DEFINITIONS(-fPIC)
ADD_LIBRARY(qtpndman ${qtpndman_SOURCES} ${qtpndman_HEADERS} ${qtpndman_HEADERS_MOC})
target_link_libraries(qtpndman pndman)

