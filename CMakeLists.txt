cmake_minimum_required(VERSION 3.2)
project(ceres)

set(CMAKE_CXX_STANDARD 11)

# eigen: version 3.3.7
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/ext/eigen)
include(eigen)

# ceres: version 1.13.0
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/ext/ceres)
include(ceres)

# targets
add_library(${PROJECT_NAME} STATIC ${CERES_SRCS})
target_link_libraries(${PROJECT_NAME} PUBLIC ${CERES_DEPS} glog gflags pthread)
