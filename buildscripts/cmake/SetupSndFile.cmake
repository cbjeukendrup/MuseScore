include(GetPlatformInfo)

if (OS_IS_WIN AND (NOT MINGW))
    find_path(SNDFILE_INCDIR sndfile.h PATHS ${DEPENDENCIES_INC};)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")
    find_library(SNDFILE_LIB NAMES sndfile libsndfile-1 PATHS ${DEPENDENCIES_LIB_DIR} NO_DEFAULT_PATH)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll")
    find_library(SNDFILE_DLL NAMES sndfile libsndfile-1 PATHS ${DEPENDENCIES_LIB_DIR} NO_DEFAULT_PATH)
    message(STATUS "Found sndfile DLL: ${SNDFILE_DLL}")

elseif (OS_IS_WASM)
    set(LIBSND_PATH "" CACHE PATH "Path to libsnd sources")
    set(LIBOGG_PATH "" CACHE PATH "Path to libogg sources")
    set(LIBVORBIS_PATH "" CACHE PATH "Path to libogg sources")
    set(SNDFILE_INCDIR LIBSND_PATH)

    muse_create_thirdparty_module(sndfile)

    target_sources(sndfile PRIVATE
        ${LIBSND_PATH}/sndfile.c
        ${LIBSND_PATH}/sndfile.hh
        ${LIBSND_PATH}/command.c
        ${LIBSND_PATH}/common.c
        ${LIBSND_PATH}/common.h
        ${LIBSND_PATH}/au.c
        ${LIBSND_PATH}/caf.c
        ${LIBSND_PATH}/file_io.c
        ${LIBSND_PATH}/ogg.c
        ${LIBSND_PATH}/ogg_vorbis.c

        #ogg
        ${LIBOGG_PATH}/include/ogg/ogg.h
        ${LIBOGG_PATH}/include/ogg/os_types.h
        ${LIBOGG_PATH}/src/bitwise.c
        ${LIBOGG_PATH}/src/framing.c

        #vorbis
        ${LIBVORBIS_PATH}/lib/vorbisenc.c
        ${LIBVORBIS_PATH}/lib/info.c
        ${LIBVORBIS_PATH}/lib/analysis.c
        ${LIBVORBIS_PATH}/lib/bitrate.c
        ${LIBVORBIS_PATH}/lib/block.c
        ${LIBVORBIS_PATH}/lib/codebook.c
        ${LIBVORBIS_PATH}/lib/envelope.c
        ${LIBVORBIS_PATH}/lib/floor0.c
        ${LIBVORBIS_PATH}/lib/floor1.c
        ${LIBVORBIS_PATH}/lib/lookup.c
        ${LIBVORBIS_PATH}/lib/lpc.c
        ${LIBVORBIS_PATH}/lib/lsp.c
        ${LIBVORBIS_PATH}/lib/mapping0.c
        ${LIBVORBIS_PATH}/lib/mdct.c
        ${LIBVORBIS_PATH}/lib/psy.c
        ${LIBVORBIS_PATH}/lib/registry.c
        ${LIBVORBIS_PATH}/lib/res0.c
        ${LIBVORBIS_PATH}/lib/sharedbook.c
        ${LIBVORBIS_PATH}/lib/smallft.c
        ${LIBVORBIS_PATH}/lib/vorbisfile.c
        ${LIBVORBIS_PATH}/lib/window.c
        ${LIBVORBIS_PATH}/lib/synthesis.c
    )

    target_include_directories(sndfile PRIVATE
        ${LIBSND_PATH}
        ${LIBOGG_PATH}/include
        ${LIBVORBIS_PATH}/include
        ${LIBVORBIS_PATH}/lib
    )

elseif (IOS)

    # IOS_CONFIG_BUG
    # For the moment, we are going to presume a pre-built libsndfile.a. It will be found at
    # ${PROJECT_SOURCE_DIR}/ios_libs/[iphoneos|iphonesimulator]/[arm64|x86_64]/ as appropriate.
    # The header is at ${PROJECT_SOURCE_DIR}/ios_libs/include.
    
    if(CMAKE_OSX_SYSROOT MATCHES "imulator")
        set(LIBSNDFILE_TARGET_OS "iphonesimulator")
    elseif(CMAKE_OSX_SYSROOT MATCHES "phone")
        set(LIBSNDFILE_TARGET_OS "iphoneos")
    else()
        message(FATAL_ERROR "Unable to determine iOS target for libsndfile.")
    endif()

    if (ARCH_IS_X86_64)
        set(LIBSNDFILE_ARCHITECTURE "x86_64")
    elseif(ARCH_IS_AARCH64)
        set(LIBSNDFILE_ARCHITECTURE "arm64")
    else()
        message(FATAL_ERROR "Unable to determine iOS processor architecture for libsndfile.")
    endif()

    # Include dir
    set (LIBSNDFILE_INCLUDE_DIR_SEARCH_PATH ${PROJECT_SOURCE_DIR}/ios_libs/include/)
    message(STATUS "Libsndfile include dir path: ${LIBSNDFILE_INCLUDE_DIR_SEARCH_PATH}")
    
    if(FALSE)
        find_path(LIBSNDFILE_INCLUDE_DIR
            NAMES sndfile.h
            PATHS ${LIBSNDFILE_INCLUDE_DIR_SEARCH_PATH}
            NO_DEFAULT_PATH
        )
        if (NOT LIBSNDFILE_INCLUDE_DIR)
            message(FATAL_ERROR "Failed to find libsndfile header in ${LIBSNDFILE_INCLUDE_DIR_SEARCH_PATH}.")
        endif()
    endif()
    
    # The above find_path() simply doesn't work. We're done wasting time on it. Do it the dumb way:
    set(LIBSNDFILE_INCLUDE_DIR ${LIBSNDFILE_INCLUDE_DIR_SEARCH_PATH})

    # Library
    set (LIBSNDFILE_LIBRARY_SEARCH_PATH ${PROJECT_SOURCE_DIR}/ios_libs/${LIBSNDFILE_TARGET_OS}/${LIBSNDFILE_ARCHITECTURE}/)
    message(STATUS "Libsndfile library dir path: ${LIBSNDFILE_LIBRARY_SEARCH_PATH}")
    
    if (FALSE)
        find_library(LIBSNDFILE_LIBRARY
            NAMES sndfile libsndfile libsndfile.a
            PATHS ${LIBSNDFILE_LIBRARY_SEARCH_PATH}
            NO_DEFAULT_PATH
        )
        if (NOT LIBSNDFILE_LIBRARY)
            message(FATAL_ERROR "Failed to find libsndfile lib in ${LIBSNDFILE_LIBRARY_SEARCH_PATH}.")
        endif()
    endif()
    
    # ...and find_library isn't working, either. It must think the paths are relative or something.
    set(LIBSNDFILE_LIBRARY "${LIBSNDFILE_LIBRARY_SEARCH_PATH}/libsndfile.a")

    if (LIBSNDFILE_LIBRARY AND LIBSNDFILE_INCLUDE_DIR)
        message(STATUS "Found libsndfile in ${LIBSNDFILE_LIBRARY_SEARCH_PATH}")
        message(STATUS "Found libsndfile include dir ${LIBSNDFILE_INCLUDE_DIR_SEARCH_PATH}")
        set(SNDFILE_LIB ${LIBSNDFILE_LIBRARY})
        set(SNDFILE_INCDIR ${LIBSNDFILE_INCLUDE_DIR})
        set(SNDFILE_FOUND 1)
    endif()
    
    # We need the ogg library, perhaps this will work:
    #set(LIBOGG_LIBRARY "${LIBSNDFILE_LIBRARY_SEARCH_PATH}/libogg.a")
    #target_link_libraries(MuseScoreStudio PUBLIC ${LIBOGG_LIBRARY})

else()
    find_package(SndFile)

    if (SNDFILE_FOUND)
    # IOS_CONFIG_BUG
    # Fixme: When building for iOS, we hit this one, which has instead found the library
    # for the host Mac. This needs to be aware of cross-compiling someday.
        message(STATUS "find_package(SndFile) succeeded.")
        set(SNDFILE_LIB ${SNDFILE_LIBRARY})
        set(SNDFILE_INCDIR ${SNDFILE_INCLUDE_DIR})
    else()
        # Use pkg-config to get hints about paths
        find_package(PkgConfig)
        if(PKG_CONFIG_FOUND)
            pkg_check_modules(LIBSNDFILE_PKGCONF sndfile>=1.0.25 QUIET)
        endif()

        # Include dir
        find_path(LIBSNDFILE_INCLUDE_DIR
            NAMES sndfile.h
            PATHS ${LIBSNDFILE_PKGCONF_INCLUDEDIR}
            NO_DEFAULT_PATH
        )

        # Library
        find_library(LIBSNDFILE_LIBRARY
            NAMES sndfile libsndfile-1
            PATHS ${LIBSNDFILE_PKGCONF_LIBDIR}
            NO_DEFAULT_PATH
        )

        if (LIBSNDFILE_LIBRARY)
            message(STATUS "find_package(SndFile) failed, had to dig for it.")
            set(SNDFILE_LIB ${LIBSNDFILE_LIBRARY})
            set(SNDFILE_INCDIR ${LIBSNDFILE_INCLUDE_DIR})
        endif()
    endif()
endif()

if (SNDFILE_INCDIR)
    message(STATUS "Found sndfile: ${SNDFILE_LIB} ${SNDFILE_INCDIR}")
else ()
    message(FATAL_ERROR "Could not find: sndfile")
endif ()
