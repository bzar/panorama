#!/bin/sh
export PATH=":${PATH:-"/usr/bin:/bin:/usr/local/bin"}"
export LD_LIBRARY_PATH="lib:${LD_LIBRARY_PATH:-"/usr/lib:/lib"}"
export QML_IMPORT_PATH=$(pwd)/imports
export QT_PLUGIN_PATH=$(pwd)/plugins
export LC_NUMERIC=en_US.utf8
export XDG_DATA_DIRS=$(pwd)/"share:${XDG_DATA_DIRS:-"/usr/share"}"
export HOME=$REAL_HOME

if [ ! -d ./interfaces/CustomPNDManager ]; then
	if [ ! -d ./interfaces ]; then
		mkdir interfaces
	fi
	mkdir interfaces/CustomPNDManager
	cp -R interfaces/PNDManager/* interfaces/CustomPNDManager
fi

if [ ! -e ./settings.cfg ]; then
	cp -R settings.cfg_default settings.cfg
fi



[ -e "./scripts/pre_script.sh" ]  && . ./scripts/pre_script.sh

./panorama $*

[ -e "./scripts/post_script.sh" ] && . ./scripts/post_script.sh
