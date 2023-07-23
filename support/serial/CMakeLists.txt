#########################
set(VERSION ${DIM}${PREC})
########################

##########################
add_definitions(-DUDF_EXPORTING)
add_definitions(-DUDF_NT)

set(FLUENT_LIB fl${LIB_RELEASE}.lib)
set(LIBS ${FLUENT_INC}\\fluent${RELEASE}\\${FLUENT_ARCH}\\${VERSION})

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
link_directories(${LIBS})
add_library(libudf SHARED ./../../${CSOURCES} ./../../${CHEADERS} ./../udf_names.c)
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/../${FLUENT_ARCH}/${VERSION})
set_target_properties(libudf PROPERTIES OUTPUT_NAME libudf)
target_link_libraries(libudf ${FLUENT_LIB})

if (${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
    add_custom_command(TARGET libudf POST_BUILD COMMAND move "$(TargetPath)" "$(TargetDir)..\\")
endif ()