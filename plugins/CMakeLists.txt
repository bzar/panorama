ADD_SUBDIRECTORY(applications)
ADD_SUBDIRECTORY(pandora)
ADD_SUBDIRECTORY(settings)
ADD_SUBDIRECTORY(systeminformation)
ADD_SUBDIRECTORY(textfile)
ADD_SUBDIRECTORY(ui)
add_subdirectory(pndmanagement)

FIND_PACKAGE(NetworkManagerQt)
IF(NetworkManagerQt_FOUND)
    add_subdirectory(networkmanager)
ELSE()
    message("NetworkManagerQt not found, not building networkmanager plugin")
ENDIF()

INSTALL(DIRECTORY metadata/ DESTINATION ${PLUGINDIR})

