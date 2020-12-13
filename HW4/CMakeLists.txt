project(HW4)

find_package(OpenMP REQUIRED)

add_executable(HW4 main.cpp)
target_link_libraries(HW4 OpenMP::OpenMP_CXX)
