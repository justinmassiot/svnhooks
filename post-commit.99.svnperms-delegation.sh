#!/bin/sh

# ============================================================================ #
#                                                                              #
#    Copyright 2018 Justin MASSIOT ( https://github.com/justinmassiot/ )       #
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

# This script allows SVN users to edit svnperms access rights from a text file
# named "svnperms.txt" placed at the root of the SVN repository.

# List of parameters:
# [1] REPOS-PATH   (the path to this repository)
# [2] REV          (the number of the revision just committed)
# [3] TXN-NAME     (the name of the transaction that has become REV)

# check if the file exists in the repository
if `svnlook tree --full-paths "$1" | grep -q '^svnperms.txt$'` ; then
  # check if the file syntax is correct
  svnlook cat "$1" svnperms.txt > "$1"/conf/svnperms.txt
  checkperms=`python "$1"/hooks/svnperms/svnperms.py -f "$1"/conf/svnperms.txt -t $3 2>&1`
  if [[ $checkperms = *"no section header"* ]] || [[ $checkperms = *"parsing error"* ]] ; then
    # exit with error
    echo $checkperms >&2
    exit 1
  else
    # overwrite the server-side "svnperms.conf" file with the latest revision of "svnperms.txt"
    svnlook cat "$1" svnperms.txt > "$1"/conf/svnperms.conf
  fi
fi

# exit without error
exit 0;
