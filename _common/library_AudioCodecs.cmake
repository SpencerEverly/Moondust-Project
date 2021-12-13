
add_library(PGE_ZLib INTERFACE)
add_library(PGE_AudioCodecs INTERFACE)

set(libZLib_A_Lib_buit    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}zlib${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}")

if(USE_SYSTEM_LIBPNG)
    find_package(ZLIB)
    message("-- Found ZLib: ${ZLIB_LIBRARIES} --")
    target_link_libraries(PGE_ZLib INTERFACE "${LIBZLIB_LIBRARY}")
    target_include_directories(PGE_ZLib INTERFACE "${ZLIB_INCLUDE_DIRS}")
    target_link_libraries(PGE_libPNG INTERFACE "${LIBZLIB_LIBRARY}")
    set(libZLib_A_Lib "${ZLIB_LIBRARIES}")
else()
    set(libZLib_A_Lib ${libZLib_A_Lib_buit})
    set(ZLIB_INCLUDE_DIRS "${DEPENDENCIES_INSTALL_DIR}/include")
    message("-- ZLib will be built (as a part of AudioCodecs): ${libZLib_A_Lib} --")
    target_link_libraries(PGE_ZLib INTERFACE "${libZLib_A_Lib}")
endif()

set(AudioCodecs_Deps)
if(NOT SDL2_USE_SYSTEM)
    list(APPEND AudioCodecs_Deps SDL2_Local)
    set(AudioCodecs_SDL2Flag "-DSDL2_REPO_PATH=${DEPENDENCIES_INSTALL_DIR}")
else()
    unset(AudioCodecs_SDL2Flag)
endif()

set(AudioCodecs_Libs
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}FLAC${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}fluidlite${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}opusfile${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}opus${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}vorbisfile${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}vorbis${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ogg${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}mad${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}modplug${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}xmp${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}ADLMIDI${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}OPNMIDI${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}EDMIDI${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}timidity_sdl2${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
    "${DEPENDENCIES_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gme${PGE_LIBS_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}"
)

# A collection of audio codecs libraries, dependency of SDL Mixer X
ExternalProject_Add(
    AudioCodecs_Local
    PREFIX ${CMAKE_BINARY_DIR}/external/AudioCodecs
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs
    CMAKE_ARGS
        "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
        "-DCMAKE_INSTALL_PREFIX=${DEPENDENCIES_INSTALL_DIR}"
        "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
        "-DCMAKE_CONFIGURATION_TYPES=${CMAKE_CONFIGURATION_TYPES}"
        ${AudioCodecs_SDL2Flag}
        $<$<BOOL:APPLE>:-DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}>
        "-DCMAKE_DEBUG_POSTFIX=d"
        "-DBUILD_MIKMOD=OFF"
        ${ANDROID_CMAKE_FLAGS}
        $<$<STREQUAL:${CMAKE_SYSTEM_NAME},Emscripten>:-DADLMIDI_USE_DOSBOX_EMULATOR=ON>
    DEPENDS ${AudioCodecs_Deps}
    BUILD_BYPRODUCTS
        ${AudioCodecs_Libs}
        "${libZLib_A_Lib_buit}"
)

target_link_libraries(PGE_AudioCodecs INTERFACE "${AudioCodecs_Libs}" ${libZLib_A_Lib})

InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libFLAC/COPYING.Xiph" RENAME "License.FLAC.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/FluidLite/LICENSE" RENAME "License.FluidLite.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libopus/COPYING" RENAME "License.Opus.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libopusfile/COPYING" RENAME "License.OpusFile.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libvorbis/COPYING" RENAME "License.Vorbis.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libogg/COPYING" RENAME "License.OGG.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libmad/COPYING" RENAME "License.libMAD.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libmodplug/COPYING" RENAME "License.libModPlug.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libxmp/COPYING.LIB" RENAME "License.libXMP.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libADLMIDI/LICENSE" RENAME "License.libADLMIDI.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libOPNMIDI/LICENSE" RENAME "License.libOPNMIDI.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libEDMIDI/LICENSE.txt" RENAME "License.libEDMIDI.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libtimidity-sdl/COPYING" RENAME "License.Timidity.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
InstallTextFile(FILE "${CMAKE_SOURCE_DIR}/_Libs/AudioCodecs/libgme/license.gpl2.txt" RENAME "License.GME.txt" DESTINATION "${PGE_INSTALL_DIRECTORY}/licenses")
