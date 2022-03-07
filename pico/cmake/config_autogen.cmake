execute_process(
  COMMAND sed -e "s,include \",include \"xx,"
  INPUT_FILE ${CMAKE_BINARY_DIR}/generated/pico_base/pico/config_autogen.h
  OUTPUT_FILE ${CMAKE_INSTALL_PREFIX}/include/pico/config_autogen.h)

execute_process(
  COMMAND egrep ^\#include
  INPUT_FILE ${CMAKE_BINARY_DIR}/generated/pico_base/pico/config_autogen.h
  OUTPUT_VARIABLE tmp)
string(REPLACE "\n" ";" tmp ${tmp})
foreach(inc ${tmp})
  string(REPLACE "#include " "" inc ${inc})
  string(REPLACE "\"" "" file ${inc})
  message("file: ${file}")
  set(copied_file "${CMAKE_INSTALL_PREFIX}/include/xx${file}")
  message("copied_file: ${copied_file}")
  get_filename_component(basename ${copied_file} DIRECTORY)
  file(MAKE_DIRECTORY ${basename})
  file(COPY_FILE ${file} ${copied_file})
endforeach()
