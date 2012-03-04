PROJECT(PNDMAN)

FIND_PACKAGE(CURL REQUIRED)
FIND_PACKAGE(OpenSSL REQUIRED)

file (GLOB_RECURSE pndman_SOURCES src/lib/*.c)
file (GLOB_RECURSE pndman_HEADERS src/lib/*.h)
SET(pndman_INCLUDES src/include/pndman.h)

INCLUDE_DIRECTORIES(src/lib/)
INCLUDE_DIRECTORIES(${JANSSON_BINARY_DIR}/include/)

FILE(COPY ${pndman_INCLUDES} DESTINATION include)
ADD_DEFINITIONS(-fPIC)
ADD_LIBRARY(pndman ${pndman_SOURCES} ${pndman_HEADERS})
target_link_libraries(pndman curl ssl jansson crypto expat)

