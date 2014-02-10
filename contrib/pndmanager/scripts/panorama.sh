#!/bin/sh
export LD_LIBRARY_PATH="lib"
export QML_IMPORT_PATH=$PWD/imports
export QT_PLUGIN_PATH=$PWD/plugins
export LC_NUMERIC=en_US.utf8
export HOME=$REAL_HOME

if [ ! -e ./settings.cfg ]; then
	cp -R settings.cfg_default settings.cfg
fi

./panorama $*

