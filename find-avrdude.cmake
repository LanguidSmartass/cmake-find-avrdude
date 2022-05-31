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
# # 'root-path' a cmake variable that is eithert containing a path to avrdude
# # or is a name of an environment variable containing a same path
#
# find_avrdude(${root-path})
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


function(__impl__find_avrdude root-path)
    set (result       "FAILURE" PARENT_SCOPE)
    set (result-msg   ""        PARENT_SCOPE)
    set (message-type "WARNING" PARENT_SCOPE)

    if (DEFINED ENV{${root-path}})
        message (STATUS "'root-path' is an environment variable name")
        set (root-path $ENV{${root-path}})
    endif()

    # check again
    if (NOT EXISTS ${root-path})
        set (result-msg "'path' " PARENT_SCOPE)
        set (
            result-msg
"'root-path' expands to: '${root-path}'
To use this function 'path' variable must be either:
- a string containing a full path to the avrdude, or
- a name of an environment variable that contains the mentioned path"
            PARENT_SCOPE
        )
        return()
    endif()


    if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
        set (exec_end ".exe")
    elseif(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")
        set (exec_end "")
    else()
        set (
            result-msg
            "${CMAKE_HOST_SYSTEM_NAME} not supported by this script"
            PARENT_SCOPE
        )
        return ()
    endif()


    set (avrdude-exe   "${root-path}/avrdude${exec_end}")
    set (avrdude-conf  "${root-path}/avrdude.conf")
    set (avrdude-pdb   "${root-path}/avrdude.pdb")


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


    set (result       "SUCCESS"                PARENT_SCOPE)
    set (result-msg   "found in: ${root-path}" PARENT_SCOPE)
    set (message-type "STATUS"                 PARENT_SCOPE)
    set (cmake-avrdude ${avrdude-exe}          PARENT_SCOPE)


endfunction()


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
function (find_avrdude root-path)

    __impl__find_avrdude(${root-path})

    message (${message-type} "find_avrdude: ${result}, ${result-msg}")

    if (${result} STREQUAL "SUCCESS")
        set (CMAKE_AVRDUDE ${cmake-avrdude} PARENT_SCOPE)
    endif()

endfunction()

