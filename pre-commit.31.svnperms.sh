#!/bin/sh

# ============================================================================ #
#                                                                              #
#    Copyright 2015 Justin MASSIOT ( https://github.com/justinmassiot/ )       #
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

# This script uses svnperms to enforce advanced path-based user rights.

# List of parameters:
# [1] REPOS-PATH   (the path to this repository)
# [2] TXN-NAME     (the name of the txn about to be committed)
python "$1"/hooks/svnperms/svnperms.py -r "$1" -t "$2" || exit 1;
# the svnperms configuration is defined in ../conf/svnperms.conf

# If we are here, it means that all checks passed, so we can allow the operation to be done.
exit 0;

