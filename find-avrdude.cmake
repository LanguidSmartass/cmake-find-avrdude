# find-avrdude.cmake
#
# @brief find_avrdude cmake function
# 
# @author Ivan Novoselov, jedi.orden@gmail.com
# 
# @date May 19, 2022
# 
# @details
#
# Usage in CMake scripts/CMakeLists.txt:
# #############################################################################
# # path-to-repo -- ditto
# include(${path-to-repo}/cmake-find-avrdude/find-avrdude.cmake)
#
# # 'path' is a cmake variable containing a path to avrdude
# # 'PATH' is a name of an environment variable containing a same path
# # at least one of them must be correctly set
#
# find_avrdude(${path}, PATH)
#
# # check if avrdude found
# if(EXISTS ${CMAKE_AVRDUDE})
#     # do your stuff or escape
# endif()
# #############################################################################
#
# @copyright MIT License
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


function(__impl__find_avrdude path env-var-name)
    set (result     "FAILURE" PARENT_SCOPE)
    set (result-msg ""      PARENT_SCOPE)

    if(NOT path AND NOT DEFINED ENV{${env-var-name}})
        set (result-msg "neither cmake 'path' nor environmental variable '${env-var-name}' are defined" PARENT_SCOPE)
        return()
    endif()

    if(NOT path)
        set (path $ENV{${env-var-name}})
    endif()

    if(NOT EXISTS ${path})
        set (result-msg "directory does not exist: '${path}'" PARENT_SCOPE)
        return()
    endif()


    if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
        set (exec_end ".exe")
    elseif(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")
        set (exec_end "")
    else()
        set (result-msg "${CMAKE_HOST_SYSTEM_NAME} not supported by this script" PARENT_SCOPE)
        return ()
    endif()


    set (avrdude-exe   "${path}/avrdude${exec_end}")
    set (avrdude-conf  "${path}/avrdude.conf")
    set (avrdude-pdb   "${path}/avrdude.pdb")


    if (NOT EXISTS "${avrdude-exe}")
        set (result-msg "avrdude executable absent" PARENT_SCOPE)
        return()
    elseif(NOT EXISTS "${avrdude-conf}")
        set (result-msg "avrdude.conf absent" PARENT_SCOPE)
        return()
    elseif(NOT EXISTS "${avrdude-pdb}")
        set (result-msg "avrdude.pdb absent" PARENT_SCOPE)
        return()
    endif()


    set (result "SUCCESS" PARENT_SCOPE)
    set (result-msg "found in: ${path}" PARENT_SCOPE)
    set (cmake-avrdude ${avrdude-exe} PARENT_SCOPE)


endfunction()


#
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
# -- on success sets a valid variable CMAKE_AVRDUDE outside of the scope of
#    this funciton
#
function (find_avrdude path env-var-name)
    __impl__find_avrdude("${path}" "${env-var-name}")

    message(STATUS "find_avrdude: ${result}, ${result-msg}")

    if (${result} STREQUAL "SUCCESS")
        set (CMAKE_AVRDUDE ${cmake-avrdude} PARENT_SCOPE)
    endif()

endfunction()

