

SET(CppUTestRootDirectory ${CMAKE_CURRENT_SOURCE_DIR}/../third/cpputest)
SET(CppUTestLibName CppUTest)
SET(CPP_PLATFORM Gcc)
include_directories(
	${CppUTestRootDirectory}/include
	${CppUTestRootDirectory}/include/CppUTest
)

add_subdirectory(${CppUTestRootDirectory}/src/CppUTest ${CMAKE_BINARY_DIR}/CppUTest)

# SET(LD_LIBRARIES "-L${CppUTestRootDirectory})/lib -lCppUTest -lCppUTestExt")

if( "${APP_BUILD_TARGET}" MATCHES "DEVICE" )
	target_compile_definitions(CppUTest PUBLIC
		CPPUTEST_USE_STD_CPP_LIB=0  # Disable STD_CPP to disable exceptions
		CPPUTEST_USE_STD_C_LIB=1
		CPPUTEST_USE_MEM_LEAK_DETECTION=0
		CPPUTEST_HAVE_GETTIMEOFDAY=1
	)
	target_sources(CppUTest	PRIVATE
		${PROJECT_SOURCE_DIR}/Src/Tests/UtestPlatform.cpp
	)
endif()
