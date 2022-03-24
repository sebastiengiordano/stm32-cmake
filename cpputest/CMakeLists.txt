set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
set(CMAKE_SYSTEM_NAME Generic)

cmake_minimum_required(VERSION 3.16)

project (Tutorial)

# Set project directory path
set (PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..)

# USage of cpputest-init.cmake like below do not work, at least we copie/paste the needed settings
# set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/cpputest-init.cmake)
set(CppUTestRootDirectory $ENV{CPPUTEST_HOME})
# set(CppUTestRootDirectory ${PROJECT_DIR}/third/cpputest)
set(CppUTestLibName CppUTest)
set(CPP_PLATFORM Gcc)
include_directories(
	${CppUTestRootDirectory}/include
	${CppUTestRootDirectory}/include/CppUTest
	# ${CppUTestRootDirectory}/include/CppUTestExt
)
add_subdirectory(${CppUTestRootDirectory}/src/CppUTest ${CMAKE_BINARY_DIR}/CppUTest)

# cmake --configure raise the following error if we "add_subdirectory" of ${CppUTestRootDirectory}/src/CppUTestExt
#       Error at ${CppUTestRootDirectory}/src/CppUTestExt/CMakeLists.txt:44 (target_link_libraries):
#       [cmake]   target_link_libraries called with incorrect number of arguments
# Note: Needed for mock functionality
# add_subdirectory(${CppUTestRootDirectory}/src/CppUTestExt ${CMAKE_BINARY_DIR}/CppUTestExt)


# Include project header files
include_directories(
    ${PROJECT_DIR}/cpputest/example-include
    ${PROJECT_DIR}/cpputest/tests/fff
    )

# Add project source
add_library(ApplicationLib
    ${PROJECT_DIR}/cpputest/example-src/Example.c
    ${PROJECT_DIR}/cpputest/tests/example-fff/FooExample.fff.c
    ${PROJECT_DIR}/cpputest/tests/fff/fff_globals.c
)

add_executable(RunAllTests
    ./tests/AllTests.cpp
    ./tests/ExampleTest.cpp
    ./tests/MyFirstTest.cpp
    ./tests/example-fff/FooExampleFFFTests.cpp
    # ./tests/io-cppumock/io_CppUMockTest.cpp
)

# cpputest_normalize_test_output_location come from CMakeLists.txt file located in ${CppUTestRootDirectory}/examples/AllTests
# In ${CppUTestRootDirectory}/CMakeLists.txt there is the following include
include("${CppUTestRootDirectory}/cmake/Modules/CppUTestNormalizeTestOutputLocation.cmake")
# If we didn't added it, cmake --configure raise the following error
#        Unknown CMake command "cpputest_normalize_test_output_location"
cpputest_normalize_test_output_location(RunAllTests)
target_link_libraries(RunAllTests ApplicationLib ${CppUTestLibName} ${CppUTestExtLibName})

# cpputest_buildtime_discover_tests come from CMakeLists.txt file located in ${CppUTestRootDirectory}/examples/AllTests
# cpputest_buildtime_discover_tests raise error, even with the following include
# include("${CppUTestRootDirectory}/cmake/Modules/CppUTestBuildTimeDiscoverTests.cmake")
# include("${CppUTestRootDirectory}/cmake/Scripts/CppUTestBuildTimeDiscoverTests.cmake")
# cpputest_buildtime_discover_tests(RunAllTests)
