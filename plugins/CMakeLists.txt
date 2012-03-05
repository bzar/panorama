ADD_SUBDIRECTORY(applications)
#ADD_SUBDIRECTORY(packages)
ADD_SUBDIRECTORY(pandora)
ADD_SUBDIRECTORY(settings)
ADD_SUBDIRECTORY(systeminformation)
ADD_SUBDIRECTORY(textfile)
ADD_SUBDIRECTORY(ui)
add_subdirectory(pndmanagement)

INSTALL(DIRECTORY metadata/ DESTINATION ${PLUGINDIR})

