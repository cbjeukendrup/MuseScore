# set(ENV{QTDIR} "$ENV{HOME}/Qt/6.2.4/ios")

#set(ENV{QTDIR} "$ENV{HOME}/Code/qt6/ios/qtbase")

#message(STATUS "SCRIPT_ARGS: ${SCRIPT_ARGS}")

# Go through the script args to find CMAKE_OSX_SYSROOT:
set(i "1")
list(LENGTH SCRIPT_ARGS nargs)
while(i LESS "${nargs}")
    list(GET SCRIPT_ARGS "${i}" ARG)
    
    if (ARG MATCHES "CMAKE_OSX_SYSROOT")
        
        if(ARG MATCHES "iphoneos")
            set(ENV{QTDIR} "$ENV{HOME}/Code/qt6_complete/qt6-build-ios-device-arm/qtbase")
        elseif(ARG MATCHES "iphonesimulator")
            set(ENV{QTDIR} "$ENV{HOME}/Code/qt6_complete/qt6-build-ios-simulator-arm/qtbase")
        else()
            message(FATAL_ERROR "Unknown CMAKE_OSX_SYSROOT: ${ARG}")
        endif()

        break()
    endif()
    math(EXPR i "${i} + 1") # next argument
endwhile()

#set(ENV{QTDIR} "$ENV{HOME}/Code/qt6_complete/qt6-build-ios-simulator-x86_64/qtbase")
#set(ENV{QTDIR} "$ENV{HOME}/Code/qt6_complete/qtbase")

# Detecting CPU architecture seems to depend on this, but it's not actually
# defined in the build output --? Or maybe it's a race condition? Deleting the
# build folder doesn't help.
#set(QTDIR "$ENV{HOME}/Code/qt6/ios/qtbase")
#set(QTDIR "$ENV{HOME}/Code/qt6_complete/qt6-build-ios-simulator-arm/qtbase")
#set(QTDIR "$ENV{HOME}/Code/qt6_complete/qt6-build-ios-simulator-x86_64/qtbase")
set(QTDIR "$ENV{HOME}/Code/qt6_complete/qtbase")

if(FALSE)

set(QT_LOCATION "$ENV{HOME}/Code/qt6/ios")
set(QT_VERSION "6.2.4")
set(QT_COMPILER "ios")


set(OS_IS_MAC 1)
set(ARCH_IS_AARCH64 1)
set(PLATFORM_DETECTED 1)

endif()
