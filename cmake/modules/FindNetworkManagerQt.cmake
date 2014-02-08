if (NetworkManagerQt_LIBRARIES AND NetworkManagerQt_INCLUDE_DIRS)
  # in cache already
  set(NetworkManagerQt_FOUND TRUE)
else (NetworkManagerQt_LIBRARIES AND NetworkManagerQt_INCLUDE_DIRS)
  find_path(NetworkManagerQt_INCLUDE_DIR
    NAMES
      NetworkManagerQt/NetworkManagerQt-export.h
    PATHS
      /usr/include
      /usr/local/include
      /opt/local/include
      /sw/include
  )

find_library(NetworkManagerQt_LIBRARY
    NAMES
      NetworkManagerQt
    PATHS
      /usr/lib
      /usr/local/lib
      /opt/local/lib
      /sw/lib
  )

set(NetworkManagerQt_INCLUDE_DIRS
  ${NetworkManagerQt_INCLUDE_DIR}
  )

if (NetworkManagerQt_LIBRARY)
  set(NetworkManagerQt_LIBRARIES
    ${NetworkManagerQt_LIBRARIES}
    ${NetworkManagerQt_LIBRARY}
    )
endif (NetworkManagerQt_LIBRARY)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(NetworkManagerQt DEFAULT_MSG
    NetworkManagerQt_LIBRARIES NetworkManagerQt_INCLUDE_DIRS)

  # show the NetworkManagerQt_INCLUDE_DIRS and NetworkManagerQt_LIBRARIES variables only in the advanced view
  mark_as_advanced(NetworkManagerQt_INCLUDE_DIRS NetworkManagerQt_LIBRARIES)

endif (NetworkManagerQt_LIBRARIES AND NetworkManagerQt_INCLUDE_DIRS)
