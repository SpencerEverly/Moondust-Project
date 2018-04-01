set(QT_EXTRA_LIBS)

find_library(QT_PRCE2 qtpcre2)
if(QT_PRCE2)
    # message("==Qt-LibPNG detected! (${QT_PRCE2})==")
    list(APPEND QT_EXTRA_LIBS ${QT_PRCE2})
endif()

find_library(QT_HARFBUZZ qtharfbuzz)
if(QT_HARFBUZZ)
    # message("==Qt-HarfBuzz detected! (${QT_HARFBUZZ})==")
    list(APPEND QT_EXTRA_LIBS ${QT_HARFBUZZ})
endif()

find_library(QT_FREETYPE qtfreetype)
if(QT_FREETYPE)
    # message("==Qt-FreeType detected! (${QT_FREETYPE})==")
    list(APPEND QT_EXTRA_LIBS ${QT_FREETYPE})
endif()

find_library(QT_PNG qtlibpng)
if(QT_PNG)
    # message("==Qt-LibPNG detected! (${QT_PNG})==")
    list(APPEND QT_EXTRA_LIBS ${QT_PNG})
endif()

find_library(QT_PTHREAD pthread)
#if(QT_PTHREAD)
#     message("==pthread detected! (${QT_PTHREAD})==")
#endif()

if(QT_EXTRA_LIBS)
    add_definitions("-DQT_STATICPLUGIN")
    set(QT_IMPORT_PLUGINS_MODULE "
        // This file is autogenerated by qmake. It imports static plugin classes for
        // static plugins specified using QTPLUGIN and QT_PLUGIN_CLASS.<plugin> variables.
        #include <QtPlugin>
        "
    )

    if(WIN32)
        set(QT_IMPORT_PLUGINS_MODULE "${QT_IMPORT_PLUGINS_MODULE}
            Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin)"
        )
    elseif("${CMAKE_SYSTEM}" MATCHES "Linux")
       # set(QT_IMPORT_PLUGINS_MODULE "${QT_IMPORT_PLUGINS_MODULE}
       #     Q_IMPORT_PLUGIN(QXcbIntegrationPlugin)
       #     Q_IMPORT_PLUGIN(QXcbEglIntegrationPlugin)"
       # )
#Q_IMPORT_PLUGIN(QXcbGlxIntegrationPlugin)
    endif()

    set(QT_IMPORT_PLUGINS_MODULE "${QT_IMPORT_PLUGINS_MODULE}
        Q_IMPORT_PLUGIN(QGifPlugin)
        Q_IMPORT_PLUGIN(QICNSPlugin)
        Q_IMPORT_PLUGIN(QICOPlugin)"
    )

    #if("${CMAKE_SYSTEM}" MATCHES "Linux")
    #    set(QT_IMPORT_PLUGINS_MODULE "${QT_IMPORT_PLUGINS_MODULE}
    #        Q_IMPORT_PLUGIN(QEglFSEmulatorIntegrationPlugin)
    #        Q_IMPORT_PLUGIN(QEglFSX11IntegrationPlugin)"
    #    )
    #endif()

    # message("Plugins:\n\n${QT_IMPORT_PLUGINS_MODULE}\n\n\n")
    
    if("${CMAKE_SYSTEM}" MATCHES "Linux")
        find_library(QT_QEGLFS  qeglfs PATHS ${CMAKE_PREFIX_PATH}/plugins/platforms)
        list(APPEND QT_EXTRA_LIBS ${QT_QEGLFS})
        find_library(QT_LINUXFB qlinuxfb PATHS ${CMAKE_PREFIX_PATH}/plugins/platforms)
        list(APPEND QT_EXTRA_LIBS ${QT_LINUXFB})

        #find_library(QT_EGLEMU  qeglfs-emu-integration PATHS ${CMAKE_PREFIX_PATH}/plugins/egldeviceintegrations)
        #list(APPEND QT_EXTRA_LIBS ${QT_EGLEMU})
        #find_library(QT_EGLX11  qeglfs-x11-integration PATHS ${CMAKE_PREFIX_PATH}/plugins/egldeviceintegrations)
        #list(APPEND QT_EXTRA_LIBS ${QT_EGLX11})

        # find_library(QT_EGLINT  qxcb-egl-integration PATHS ${CMAKE_PREFIX_PATH}/plugins/xcbglintegrations)
        # list(APPEND QT_EXTRA_LIBS ${QT_EGLINT})
        # find_library(QT_GLXINT  qxcb-glx-integration PATHS ${CMAKE_PREFIX_PATH}/plugins/xcbglintegrations)
        # list(APPEND QT_EXTRA_LIBS ${QT_GLXINT})

        find_library(QT_QXCB    qxcb PATHS ${CMAKE_PREFIX_PATH}/plugins/platforms)
        list(APPEND QT_EXTRA_LIBS ${QT_QXCB})

        find_package(X11 REQUIRED)
        list(APPEND QT_EXTRA_LIBS ${X11_LIBRARIES})

        find_library(QT_QGIF    qgif PATHS ${CMAKE_PREFIX_PATH}/plugins/imageformats)
        list(APPEND QT_EXTRA_LIBS ${QT_QGIF})
        find_library(QT_ICNS    qicns PATHS ${CMAKE_PREFIX_PATH}/plugins/imageformats)
        list(APPEND QT_EXTRA_LIBS ${QT_ICNS})
        find_library(QT_ICO     qico PATHS ${CMAKE_PREFIX_PATH}/plugins/imageformats)
        list(APPEND QT_EXTRA_LIBS ${QT_ICO})
    endif()

    if("${CMAKE_SYSTEM}" MATCHES "Linux")
	find_library(QT_GLIB glib NAMES glib glib-2.0)
        if(QT_GLIB)
            # message("==GLib detected! (${QT_GLIB})==")
            list(APPEND QT_EXTRA_LIBS ${QT_GLIB})
        endif()
        find_library(QT_XCB xcb-static)
        if(QT_XCB)
            # message("==XCB detected! (${QT_XCB})==")
            list(APPEND QT_EXTRA_LIBS ${QT_XCB})
        endif()
        #find_library(QT_xcb2 xcb)
        #if(QT_xcb2)
        #    # message("==X11 detected! (${QT_xcb2})==")
        #    list(APPEND QT_EXTRA_LIBS ${QT_xcb2})
        #endif()
        #find_library(QT_X11 X11)
        #if(QT_X11)
        #    # message("==X11 detected! (${QT_X11})==")
        #    list(APPEND QT_EXTRA_LIBS ${QT_X11})
        #endif()
        find_library(QT_DL glib NAMES dl)
        if(QT_DL)
            # message("==DL detected! (${QT_DL})==")
            list(APPEND QT_EXTRA_LIBS ${QT_DL})
        endif()
    endif()
    # message("==Full list of libs: ${QT_EXTRA_LIBS}==")
endif()

