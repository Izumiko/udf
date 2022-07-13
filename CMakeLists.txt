#########################
set(CSOURCES DPM.cpp)#only one#
set(CHEADERS)#only one#
set(DIM 3d)
########################

cmake_minimum_required(VERSION 3.19)
project(udf)
set(PARALLEL_NODE intel)
SET(RELEASE 22.2.0)
SET(FLUENT_ARCH win64)
set(LIB_RELEASE 2220)
SET(FLUENT_INC $ENV{FLUENT_INC})

#################################################################
execute_process(COMMAND ${PROJECT_SOURCE_DIR}/support/pre_chore.cmd
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/support
		)

execute_process(COMMAND ${CMAKE_COMMAND} -E
		copy ${PROJECT_SOURCE_DIR}/${CSOURCES} ${PROJECT_SOURCE_DIR}/support
		)


configure_file(${PROJECT_SOURCE_DIR}/support/pre_pre_make.cmd ${PROJECT_SOURCE_DIR}/support/pre_make.cmd)
execute_process(COMMAND ${PROJECT_SOURCE_DIR}/support/pre_make.cmd
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/support
		)
ADD_SUBDIRECTORY(support/host)
ADD_SUBDIRECTORY(support/node)
