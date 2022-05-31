# cmake-find-avrdude
A simple cmake function that helps to find avrdude

## How to use in CMake scripts/CMakeLists.txt:

```cmake
#path-to-repo -- ditto
include(${path-to-repo}/cmake-find-avrdude/find-avrdude.cmake)

# 'root-path' a cmake variable that is eithert containing a path to avrdude
# or is a name of an environment variable containing a same path

find_avrdude(${root-path})

# check if avrdude found
if(EXISTS ${CMAKE_AVRDUDE})
    # do your stuff or escape
endif()
```

## Verbose desctiption
```cmake
# @brief find_avrdude
#
# Searches for 3 avrdude files: avrdude executable, avrdude.pdb and avrdude.conf
# -- first checks if ${root-path} is an environment variable name
#    if it is -- expands it's value and goes with that
# -- if it isn't -- assumes it's a string with full path
#
# @param path -- explicit path to avrdude installation,
#                or name of an environment variable that expands
# @result
# -- on success/failure prints STATUS/WARNING with an appropriate message
# -- on success sets a valid variable CMAKE_AVRDUDE outside of the scope of
#    this funciton
function (find_avrdude path env-var-name)
```