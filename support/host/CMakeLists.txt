#########################
set(VERSION ${DIM}dp_host)
########################

##########################
ADD_DEFINITIONS(-DUDF_EXPORTING)
ADD_DEFINITIONS(-DUDF_NT)
IF ((${VERSION} STREQUAL 2d_host) OR (${VERSION} STREQUAL 3d_host) OR (${VERSION} STREQUAL 2ddp_host) OR (${VERSION} STREQUAL 3ddp_host))
	set(COMM net)
	set(FLUENT_LIB mport.lib fl${LIB_RELEASE}.lib)
	set(LIBS ${FLUENT_INC}\\fluent${RELEASE}\\${FLUENT_ARCH}\\${VERSION} ${FLUENT_INC}\\fluent${RELEASE}\\MULTIPORT\\${FLUENT_ARCH}\\${COMM}\\SHARED)
ELSEIF ((${VERSION} STREQUAL 2d) OR (${VERSION} STREQUAL 3d) OR (${VERSION} STREQUAL 2ddp) OR (${VERSION} STREQUAL 3ddp))
	set(FLUENT_LIB fl${LIB_RELEASE}.lib)
	set(LIBS ${FLUENT_INC}\\fluent${RELEASE}\\${FLUENT_ARCH}\\${VERSION})
ELSEIF ((${VERSION} STREQUAL 2d_node) OR (${VERSION} STREQUAL 3d_node) OR (${VERSION} STREQUAL 2ddp_node) OR (${VERSION} STREQUAL 3ddp_node))
	IF ((NOT (${PARALLEL_NODE} STREQUAL none)) AND (NOT (${PARALLEL_NODE} STREQUAL net)))
		set(PARALLEL_NODE mpi)
	ENDIF ()
	SET(COMM mpi)
	set(FLUENT_LIB fl_${PARALLEL_NODE}${LIB_RELEASE} mport)
	set(LIBS ${FLUENT_INC}\\fluent${RELEASE}\\${FLUENT_ARCH}\\${VERSION}
			${FLUENT_INC}\\fluent${RELEASE}\\MULTIPORT\\${FLUENT_ARCH}\\${COMM}\\SHARED
			${FLUENT_INC}\\ntbin\\clang\\lib)
ENDIF ()

include_directories(
		${PROJECT_SOURCE_DIR}/support
		${FLUENT_INC}\\fluent${RELEASE}\\${FLUENT_ARCH}\\${VERSION}
		${FLUENT_INC}\\fluent${RELEASE}\\src\\main
		${FLUENT_INC}\\fluent${RELEASE}\\src\\addon-wrapper
		${FLUENT_INC}\\fluent${RELEASE}\\src\\io
		${FLUENT_INC}\\fluent${RELEASE}\\src\\species
		${FLUENT_INC}\\fluent${RELEASE}\\src\\pbns
		${FLUENT_INC}\\fluent${RELEASE}\\src\\numerics
		${FLUENT_INC}\\fluent${RELEASE}\\src\\sphysics
		${FLUENT_INC}\\fluent${RELEASE}\\src\\storage
		${FLUENT_INC}\\fluent${RELEASE}\\src\\mphase
		${FLUENT_INC}\\fluent${RELEASE}\\src\\bc
		${FLUENT_INC}\\fluent${RELEASE}\\src\\models
		${FLUENT_INC}\\fluent${RELEASE}\\src\\material
		${FLUENT_INC}\\fluent${RELEASE}\\src\\amg
		${FLUENT_INC}\\fluent${RELEASE}\\src\\util
		${FLUENT_INC}\\fluent${RELEASE}\\src\\mesh
		${FLUENT_INC}\\fluent${RELEASE}\\src\\udf
		${FLUENT_INC}\\fluent${RELEASE}\\src\\ht
		${FLUENT_INC}\\fluent${RELEASE}\\src\\dx
		${FLUENT_INC}\\fluent${RELEASE}\\src\\turbulence
		${FLUENT_INC}\\fluent${RELEASE}\\src\\acoustics
		${FLUENT_INC}\\fluent${RELEASE}\\src\\parallel
		${FLUENT_INC}\\fluent${RELEASE}\\src\\etc
		${FLUENT_INC}\\fluent${RELEASE}\\src\\ue
		${FLUENT_INC}\\fluent${RELEASE}\\src\\dpm
		${FLUENT_INC}\\fluent${RELEASE}\\src\\dbns
		${FLUENT_INC}\\fluent${RELEASE}\\cortex\\src
		${FLUENT_INC}\\fluent${RELEASE}\\client\\src
		${FLUENT_INC}\\fluent${RELEASE}\\tgrid\\src
		${FLUENT_INC}\\fluent${RELEASE}\\multiport\\src
		${FLUENT_INC}\\fluent${RELEASE}\\multiport\\mpi_wrapper\\src
		${FLUENT_INC}\\include)
LINK_DIRECTORIES(${LIBS})
ADD_LIBRARY(libudf SHARED ./../../${CSOURCES} ./../../${CHEADERS} ./../udf_names.c)
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/../${FLUENT_ARCH}/${VERSION})
TARGET_LINK_LIBRARIES(libudf ${FLUENT_LIB})
