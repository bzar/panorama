README
======

This is the source distribution for the Panorama project. It is licensed under the
[Creative Commons Attribution Share-Alike][ccbysa] license.

About
-----

Panorama is an application launcher written in Qt for the [OpenPandora][] portable
gaming platform. The focus lies on creating an extremely portable, modular and
extensible system that also is visually appealing and uses little resources. Having
intuitive controls and an efficient usage of screen real estate is also a primary
goal.

Building the source code
------------------------

You will need the following tools and resources to compile Panorama:

*   A C++ compiler
*   [Git][]
*   CMake
*   Make
*   Qt 4.8 or later

Once you have these tools, you should get hold of the latest version of the
Panorama source code distribution, which you can do by going to the
[GitHub repository][github] for Panorama. You'll also need the Pandora
libraries that are used for PND software package integration. You can get
them using the following commands:

    git submodule update --init --recursive
    mkdir build && cd build
    cmake ..
    make

To create a monolithic (everything in one directory) build for testing or packaging, do

    git submodule update --init --recursive
    mkdir build && cd build
    cmake -DPANDORA=ON -DCMAKE_INSTALL_PREFIX=install ..
    make install
    
to install a properly configured version to build/install.

Further documentation
---------------------
If you want to find out more about Panorama, please visit the project's
[Wiki][]. There, you will find guides for creating new Panorama UIs or extending
the project.

[ccbysa]: http://creativecommons.org/licenses/by-sa/3.0/ (Creative Commons Attribution Share-Alike)
[openpandora]: http://openpandora.org/ (OpenPandora - The OMAP3 based Handheld)
[git]: http://git-scm.com/ (Git)
[github]: http://github.com/bzar/panorama (GitHub)
[wiki]: http://wiki.github.com/dflemstr/panorama (Wiki)
