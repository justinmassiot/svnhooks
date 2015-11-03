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

# This script sends requests to Redmine in order to keep it in sync with the current SVN repository.

# List of parameters:
# [1] REPOS-PATH   (the path to this repository)
# [2] REV          (the number of the revision just committed)
# [3] TXN-NAME     (the name of the transaction that has become REV)

# http://www.redmine.org/projects/redmine/wiki/HowTo_setup_automatic_refresh_of_repositories_in_Redmine_on_commit#Subversion
$REDMINE_KEY="{{ MyRedmineKey }}"
curl "http://{{ MyRedmineURL }}/redmine/sys/fetch_changesets?key=$REDMINE_KEY"

exit 0;

