cmake_minimum_required(VERSION 3.13)

include(pico_sdk_import.cmake)

project(wrap_pico_sdk)

pico_sdk_init()

add_library(wrap_pico_stdlib)
target_link_libraries(wrap_pico_stdlib PUBLIC pico_stdlib)
set_target_properties(wrap_pico_stdlib PROPERTIES OUTPUT_NAME pico_stdlib)
install(TARGETS wrap_pico_stdlib
  LIBRARY DESTINATION lib
)

add_library(wrap_hardware_spi)
target_link_libraries(wrap_hardware_spi PUBLIC
  hardware_spi
  hardware_clocks
  hardware_resets)
set_target_properties(wrap_hardware_spi PROPERTIES OUTPUT_NAME hardware_spi)
install(TARGETS wrap_hardware_spi
  LIBRARY DESTINATION lib
)

# rp2040 includes
foreach(target hardware_regs hardware_structs)
  install(
    DIRECTORY ${PICO_SDK_PATH}/src/rp2040/${target}/include/hardware
    DESTINATION include)
endforeach()

# rp2_common includes
foreach(target pico_platform pico_stdio)
  install(
    DIRECTORY ${PICO_SDK_PATH}/src/rp2_common/${target}/include/pico
    DESTINATION include)
endforeach()
foreach(target
    hardware_base
    hardware_gpio
    hardware_uart
    hardware_divider
    hardware_timer
    hardware_resets
    hardware_clocks
    hardware_spi)
  install(
    DIRECTORY ${PICO_SDK_PATH}/src/rp2_common/${target}/include/hardware
    DESTINATION include)
endforeach()

# common includes
foreach(target pico_base pico_time pico_util pico_stdlib)
  file(GLOB_RECURSE h ${PICO_SDK_PATH}/src/common/${target}/include/*.h)
  install(FILES ${h} DESTINATION include)
  install(
    DIRECTORY ${PICO_SDK_PATH}/src/common/${target}/include/pico
    DESTINATION include
    FILES_MATCHING PATTERN *.h)
endforeach()
install(
  FILES ${CMAKE_BINARY_DIR}/generated/pico_base/pico/version.h
  DESTINATION include/pico)
install(SCRIPT config_autogen.cmake)
