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

# This script allows the modification of *some* revision properties for *certain* users.

# List of parameters:
# [1] REPOS-PATH   (the path to this repository)
# [2] REV          (the revision being tweaked)
# [3] USER         (the username of the person tweaking the property)
# [4] PROPNAME     (the property being set on the revision)
# [5] ACTION       (the property is being 'A'dded, 'M'odified, or 'D'eleted)
REPOS="$1"
REV="$2"
USER="$3"
PROPNAME="$4"
ACTION="$5"

# definition of the authz file that contains the definition of the administrator group
AUTHZ_FILE_PATH="{{ /path/to/your/authz/file }}"
ADMIN_GROUP_NAME="{{ AdminGroupName }}"


# modification of a commit property
if [ "$ACTION" = "M" ] ; then
  # get the author of the commit
  AUTHOR=`svnlook author -r "$REV" "$REPOS"`
  
  if [ "$USER" = "$AUTHOR" -a "`cat $AUTHZ_FILE_PATH | grep ''^$ADMIN_GROUP_NAME\ *='' | grep $USER`" = "" ] ; then
    # if the current user is the author but not an administrator ...
    if [ "$PROPNAME" = "svn:log" ] ; then
      # ... he/she is allowed to edit the log message
      exit 0
    else
      echo "----------" 1>&2
      echo "You ($USER) are not allowed to change the $PROPNAME property. Changing revision properties other than svn:log is prohibited." 1>&2
      echo "Please contact your SVN administrator." 1>&2
      echo "----------" 1>&2
    fi
    
  elif [ "`cat $AUTHZ_FILE_PATH | grep ''^$ADMIN_GROUP_NAME\ *='' | grep $USER`" = "" != "" ] ; then
    # if the current user is an administrator ...
    if [ "$PROPNAME" = "svn:author" -o "$PROPNAME" = "svn:date" -o "$PROPNAME" = "svn:log" ] ; then
      # ... he/she is allowed to edit the properties "log", "date" and "author"
      exit 0
    else
      echo "----------" 1>&2
      echo "You ($USER) are not allowed to change the $PROPNAME property. Changing revision properties other than svn:author, svn:date and svn:log is prohibited." 1>&2
      echo "Please contact your SVN administrator." 1>&2
      echo "----------" 1>&2
    fi
  
  else
    # the user is neither the author nor an administrator
    echo "----------" 1>&2
    echo "You ($USER) are not allowed to change revision properties." 1>&2
    echo "Please contact your SVN administrator." 1>&2
    echo "----------" 1>&2
  fi
  
fi

# If we are here, it means that some checks failed, so we stop the pending operation.
exit 1

