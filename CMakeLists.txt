cmake_minimum_required(VERSION 3.29)

project(cpp-hello VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Boost REQUIRED)
find_package(fmt REQUIRED)

add_executable(${PROJECT_NAME} src/main.cpp)

target_compile_definitions(${PROJECT_NAME} PRIVATE CMAKE_CXX_COMPILER_ID="${CMAKE_CXX_COMPILER_ID}")
target_include_directories(${PROJECT_NAME} PRIVATE ${fmt_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE Boost::headers fmt::fmt)

install(TARGETS ${PROJECT_NAME} RUNTIME)
