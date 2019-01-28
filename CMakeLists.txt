cmake_minimum_required(VERSION 3.13)

execute_process(COMMAND xcrun --sdk iphoneos --show-sdk-path OUTPUT_VARIABLE CMAKE_OSX_SYSROOT
        OUTPUT_STRIP_TRAILING_WHITESPACE)
set(CMAKE_C_FLAGS_INIT "${CMAKE_C_FLAGS_INIT} -arch arm64 -Wno-missing-braces")
set(CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} -arch arm64 -Wno-missing-braces")
set_property(GLOBAL PROPERTY MACOSX_BUNDLE YES)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_CONFIGURATION_TYPES Debug Release RelWithDebInfo)
set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "12.0")

project(MachMessagesCPP)

set(CMAKE_CXX_STANDARD 17)

#Use for debug logs
#add_definitions(-DDEBUG)

add_library(MachMessagesCPP STATIC MachMessages/MachMessage.mm MachMessages/MachMessage.h MachMessages/MachPort.mm MachMessages/MachPort.h MachMessages/MachMessageComplex.mm MachMessages/MachMessageComplex.h MachMessages/MachMessageData.mm MachMessages/MachMessageData.h MachMessages/MachMessageDescriptor.mm MachMessages/MachMessageDescriptor.h MachMessages/Logger.h MachMessages/MachConnection.mm MachMessages/MachConnection.h MachMessages/MachExceptions.h MachServices/MachServiceBase.mm MachServices/MachServiceBase.h)
target_link_libraries(
        ${PROJECT_NAME}
        "-framework Foundation"
        "-framework IOKit"
        "-framework CoreFoundation"
        "-framework UIKit"
        "-framework MobileCoreServices"
        "-framework ImageIO"
        "-framework AVFoundation"
        "-framework CoreMedia"
        "-framework Security"
        "-framework VideoToolBox"
        )