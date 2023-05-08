cmake_minimum_required(VERSION 3.25)

project({{ .ProjectName }} CXX)

set(CMAKE_CXX_STANDARD {{ .CppStandard }})

include_directories(include)

add_subdirectory(src)
add_subdirectory(tests)
add_subdirectory(examples)
