#SETTINGS
############################
set(CSOURCES example.c) #only one#
set(CHEADERS)           #only one#
set(DIM 3d)             #3D
SET(RELEASE 22.2.0)     #22.2.0=Fluent 2022R2
SET(FLUENT_ARCH win64)  #Windows 64bit
set(LIB_RELEASE 2220)   #2220=Fluent 2022R2
set(PARALLEL_NODE intel)
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
SET(UDFNAMES ${PROJECT_SOURCE_DIR}/support/udf_names.c)
file(WRITE ${UDFNAMES} "/* This file generated automatically. */\n/*          Do not modify.            */\n")
file(APPEND ${UDFNAMES} "#include \"udf.h\"\n#include \"prop.h\"\n#include \"dpm.h\"\n")
file(STRINGS ${CSOURCES} FUNCS REGEX "^ *DEFINE_[_A-Z]+ *\\(.*\\)")
foreach(F IN LISTS FUNCS)
	string(REGEX REPLACE "^ *(DEFINE_[_A-Z]+ *\\(.*\\)).*"
			"extern \\1;" FN ${F})
	file(APPEND ${UDFNAMES} "${FN}\n")
endforeach()
file(APPEND ${UDFNAMES} "__declspec(dllexport) UDF_Data udf_data[] = {\n")
foreach(F IN LISTS FUNCS)
	string(REGEX REPLACE "^ *DEFINE_([_A-Z]+) *\\( *([_a-zA-Z0-9]+).*\\).*"
			"{\"\\2\", (void (*)(void))\\2, UDF_TYPE_\\1}," UDFDATA ${F})
	file(APPEND ${UDFNAMES} "${UDFDATA}\n")
endforeach()
file(APPEND ${UDFNAMES} "};\n__declspec(dllexport) int n_udf_data = sizeof(udf_data)/sizeof(UDF_Data);\n")
file(APPEND ${UDFNAMES} "#include \"version.h\"\n")
file(APPEND ${UDFNAMES} "__declspec(dllexport) void UDF_Inquire_Release(int *major, int *minor, int *revision)\n")
file(APPEND ${UDFNAMES} "{\n  *major = RampantReleaseMajor;\n")
file(APPEND ${UDFNAMES} "  *minor = RampantReleaseMinor;\n")
file(APPEND ${UDFNAMES} "  *revision = RampantReleaseRevision;\n}\n")

# Generate udf io header with fluent's resolve command
if(WIN32)
execute_process(COMMAND "${FLUENT_INC}\\ntbin\\win64\\resolve.exe" -udf "${PROJECT_SOURCE_DIR}\\${CSOURCES}" -head_file ud_io1.h
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/support
		)
endif()

# Add actual project files of host and node version
ADD_SUBDIRECTORY(support/host)
ADD_SUBDIRECTORY(support/node)
