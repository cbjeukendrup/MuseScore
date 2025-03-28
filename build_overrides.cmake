# set(ENV{QTDIR} "$ENV{HOME}/Qt/6.2.4/ios")

#set(ENV{QTDIR} "$ENV{HOME}/Code/qt6/ios/qtbase")
set(ENV{QTDIR} "$ENV{HOME}/Code/qt6_complete/qt6-build-ios-simulator-arm/qtbase")

# Detecting CPU architecture seems to depend on this, but it's not actually
# defined in the build output --? Or maybe it's a race condition? Deleting the
# build folder doesn't help.
#set(QTDIR "$ENV{HOME}/Code/qt6/ios/qtbase")
set(QTDIR "$ENV{HOME}/Code/qt6_complete/qt6-build-ios-simulator-arm/qtbase")

if(FALSE)

set(QT_LOCATION "$ENV{HOME}/Code/qt6/ios")
set(QT_VERSION "6.2.4")
set(QT_COMPILER "ios")


set(OS_IS_MAC 1)
set(ARCH_IS_AARCH64 1)
set(PLATFORM_DETECTED 1)

endif()
