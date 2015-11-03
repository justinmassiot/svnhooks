#!/bin/bash
# Don't use #!/bin/sh for this script because the array splitting ${@:2} is misinterpreted on some Linux systems. See http://stackoverflow.com/a/20616103 .

# ============================================================================ #
#                                                                              #
#    Copyright 2015, Justin MASSIOT ( https://github.com/justinmassiot/ )      #
#                                                                              #
#    Licensed under the Apache License, Version 2.0 (the "License");           #
#    you may not use this file except in compliance with the License.          #
#    You may obtain a copy of the License at                                   #
#                                                                              #
#        http://www.apache.org/licenses/LICENSE-2.0                            #
#                                                                              #
#    Unless required by applicable law or agreed to in writing, software       #
#    distributed under the License is distributed on an "AS IS" BASIS,         #
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  #
#    See the License for the specific language governing permissions and       #
#    limitations under the License.                                            #
#                                                                              #
# ============================================================================ #

if [ "$#" -ne 3 ] ; then
  echo "Illegal number of parameters, must be equal to 3."
fi

# ==========

# get the script path
HOOK_PATH="$1"
# set a default value to the RETURN variable
RETURN=0

# ==========

# Loop through all the files inside the original hook folder and execute all scripts that match the filename pattern.
#   example: If the original file is "pre-commit", this will run "pre-commit.01", "pre-commit.51", "pre-commit.02.py" but not "pre-commit.tmpl" or "pre-commit01"
# Warning, the regular expression is not like the one we commonly use:
#   -> the dot (.) is not a special character, it really matches a dot
#   -> the star (*) is the wildcard, and does not mean "any number of matches"
#   -> the plus (+) means "at least one match" and must be placed BEFORE the expression
for HOOK_SCRIPT in ${HOOK_PATH}*[0-9]*
do
  if [ -x $HOOK_SCRIPT ] ; then # check if file exists and is executable
    # run each script and get the return code
    $HOOK_SCRIPT "${@:2}" # pass all parameters to the sub-script, except the first one (HOOK_PATH)
    RETURN=$?
    if [ $RETURN -ne 0 ] ; then # exit result is a non-zero => error
       break; # exit the loop with the non-zero return code
    fi
  fi
done

exit $RETURN

