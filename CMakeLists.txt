#SETTINGS
############################
set(CSOURCES example.c) #only one#
set(CHEADERS)           #only one#
set(DIM 3d)             #3D
set(PREC dp)            #Precision: dp=double precision, empty for single precision
set(PARALLEL TRUE)      #Parallel or Serial
SET(RELEASE 22.2.0)     #22.2.0=Fluent 2022R2
SET(FLUENT_ARCH win64)  #Windows 64bit
set(LIB_RELEASE 2220)   #2220=Fluent 2022R2
#############################

cmake_minimum_required(VERSION 3.19)
project(udf)

# Get FLUENT_INC from environment variable
string(SUBSTRING ${LIB_RELEASE} 0 3 SHORTVER)
string(APPEND ROOT_PATH AWP_ROOT ${SHORTVER})
string(APPEND FLUENT_INC $ENV{${ROOT_PATH}} "\\fluent")

# Remove outdated c and h files
file(REMOVE "${PROJECT_SOURCE_DIR}/support/*.c" "${PROJECT_SOURCE_DIR}/support/*.h")

# Generate udf_names.c based on user's udf file
file(STRINGS ${CSOURCES} FUNCS REGEX "^ *DEFINE_[_A-Z]+ *\\(.*\\)")
set(FUNCS_DECL "")
set(FUNCS_DATA "")
foreach(F IN LISTS FUNCS)
	string(REGEX REPLACE "^ *(DEFINE_[_A-Z]+ *\\(.*\\)).*"
			"extern \\1;\n" FN ${F})
	string(REGEX REPLACE "^ *DEFINE_([_A-Z]+) *\\( *([_a-zA-Z0-9]+).*\\).*"
			"{\"\\2\", (void (*)(void))\\2, UDF_TYPE_\\1},\n" UDFDATA ${F})
	set(FUNCS_DECL ${FUNCS_DECL}${FN})
	set(FUNCS_DATA ${FUNCS_DATA}${UDFDATA})
endforeach()
configure_file(${PROJECT_SOURCE_DIR}/support/udf_names.c.in ${PROJECT_SOURCE_DIR}/support/udf_names.c)

# Generate udf io header with fluent's resolve command
if(WIN32)
	execute_process(COMMAND "${FLUENT_INC}\\ntbin\\win64\\resolve.exe" -udf "${PROJECT_SOURCE_DIR}\\${CSOURCES}" -head_file ud_io1.h
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/support
		)
endif()

# Add actual project files of parallel (host/node) or serial.
if (PARALLEL)
	add_subdirectory(support/host)
	add_subdirectory(support/node)
else ()
	add_subdirectory(support/serial)
endif ()