## How to use

Just add these lines to your CPP project
add_subdirectory(MachMessagesCPP ${CMAKE_BINARY_DIR}/MachMessagesCPP)

target_link_libraries(${PROJECT_NAME}
        MachMessagesCPP
        ...
        ..)
        
You can see test on how to use the library