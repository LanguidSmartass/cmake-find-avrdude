# cmake-find-avrdude
A simple cmake function that helps to find avrdude

## How to use in CMake scripts/CMakeLists.txt:

```cmake
# path-to-repo -- ditto
include(${path-to-repo}/cmake-find-avrdude/find-avrdude.cmake)

# 'path' is a cmake variable containing a path to avrdude
# 'PATH' is a name of an environment variable containing a same path
# at least one of them must be correctly set

find_avrdude(${path}, PATH)

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
# -- first tries ${path}
# -- on failure tries ENV{${env-var-name}}
#
# @param path -- explicit path to avrdude installation
# @param env-var-name -- name of an environment variable that expands
# @result
# -- on success/failure prints status with a message of success/failure
# -- on success sets a variable CMAKE_AVRDUDE outside of the scope of
#    this funciton
# -- on failure to find sets a variable CMAKE_AVRDUDE-NOTFOUND
# -- on other failures reports SEND_ERROR indicating that there is something
#    wrong with this script
function (find_avrdude path env-var-name)
```