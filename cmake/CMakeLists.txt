cmake_minimum_required(VERSION 3.5.0)
project(AirSim)

LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake-modules)
MESSAGE(STATUS "cmake modues ${CMAKE_MODULE_PATH}")
find_package(Eigen3 REQUIRED)

add_subdirectory("rpclib_wrapper")
add_subdirectory("AirLib")
add_subdirectory("MavLinkCom")
add_subdirectory("AirLibUnitTests")
add_subdirectory("HelloDrone")
add_subdirectory("HelloCar")
add_subdirectory("DroneShell")
add_subdirectory("DroneServer")


