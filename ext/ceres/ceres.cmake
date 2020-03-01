cmake_minimum_required(VERSION 3.2)
set(CMAKE_CXX_STANDARD 11)

# cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

# find external packages
find_package(LAPACK QUIET REQUIRED)
find_package(BLAS QUIET REQUIRED)
find_package(SuiteSparse REQUIRED)
find_package(CXSparse REQUIRED)
find_package(Threads REQUIRED)
find_package(OpenMP QUIET)
if (OPENMP_FOUND)
	message("-- Building with OpenMP.")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
endif (OPENMP_FOUND)

# modify include/ceres/internal/config.h according to external packages

# external header directories
include_directories(${SUITESPARSE_INCLUDE_DIRS})
include_directories(${CXSPARSE_INCLUDE_DIRS})
include_directories(${GFLAGS_INCLUDE_DIRS})

# header directories
include_directories(${CMAKE_CURRENT_LIST_DIR} ${CMAKE_CURRENT_LIST_DIR}/include
		${CMAKE_CURRENT_LIST_DIR}/internal ${CMAKE_CURRENT_LIST_DIR}/internal/ceres)

# header files
file(GLOB CERES_INTERNAL_HDRS ${CMAKE_CURRENT_LIST_DIR}/internal/ceres/*.h)
file(GLOB CERES_PUBLIC_HDRS ${CMAKE_CURRENT_LIST_DIR}/include/ceres/*.h)
file(GLOB CERES_PUBLIC_INTERNAL_HDRS ${CMAKE_CURRENT_LIST_DIR}/include/ceres/internal/*.h)

# source files
file(GLOB CERES_INTERNAL_SRCS ${CMAKE_CURRENT_LIST_DIR}/internal/ceres/*.cc)
file(GLOB CERES_INTERNAL_SCHUR_FILES ${CMAKE_CURRENT_LIST_DIR}/internal/ceres/generated/*.cc)
set(CERES_SRCS ${CERES_INTERNAL_HDRS} ${CERES_INTERNAL_SRCS}
		${CERES_PUBLIC_HDRS} ${CERES_PUBLIC_INTERNAL_HDRS} ${CERES_INTERNAL_SCHUR_FILES})

# remove test source files
file(GLOB CERES_INTERNAL_TEST_SRC
		${CMAKE_CURRENT_LIST_DIR}/internal/ceres/*test*.cc
		${CMAKE_CURRENT_LIST_DIR}/internal/ceres/*mock*.cc)
list(REMOVE_ITEM CERES_SRCS ${CERES_INTERNAL_TEST_SRC})

## definitions
add_definitions(-DCERES_SUITESPARSE_VERSION="${SUITESPARSE_VERSION}" # suitesparse
		-DCERES_CXSPARSE_VERSION="${CXSPARSE_VERSION}") # cxspace

# dependencies
list(APPEND CERES_DEPS ${SUITESPARSE_LIBRARIES} ${CXSPARSE_LIBRARIES} ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES} pthread)
if (OPENMP_FOUND)
	list(APPEND CERES_DEPS gomp)
endif (OPENMP_FOUND)

