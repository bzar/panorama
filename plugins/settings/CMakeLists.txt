PROJECT(SETTINGS)

FIND_PACKAGE(Qt5Qml REQUIRED)
FIND_PACKAGE(Qt5Quick REQUIRED)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

SET(settings_SOURCES
    src/settingsplugin.cpp
    src/configuration.cpp
    src/setting.cpp
    src/settingshive.cpp
    src/settingssource.cpp)

SET(settings_HEADERS
    src/settingsplugin.h
    src/configuration.h
    src/setting.h
    src/settingshive.h
    src/settingssource.h)

ADD_DEFINITIONS(${QT_DEFINITIONS} -DQT_PLUGIN -DQT_SHARED)
ADD_LIBRARY(settings MODULE ${settings_SOURCES})
qt5_use_modules(settings Qml Quick)

INSTALL(TARGETS settings DESTINATION ${PLUGINDIR}/Panorama/Settings)

