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

# This script verifies that the SVN log message complies with the process of (y)our organization.

# List of parameters:
# [1] REPOS-PATH   (the path to this repository)
# [2] TXN-NAME     (the name of the txn about to be committed)
REPOS="$1"
TXN="$2"

# minimum number of words in a log message
WORD_COUNT_MIN=3


# 1- Check for blank/empty commit messages
LOGMSG_EMPTY=0
`svnlook log -t "$TXN" "$REPOS" | grep "[a-zA-Z0-9]" > /dev/null` || LOGMSG_EMPTY=1
if [ "$LOGMSG_EMPTY" -eq 1 ] ; then
  # if the message is empty, exit with an error
  echo "----------" 1>&2
  echo "Empty log messages are not allowed." 1>&2
  echo "Please provide a meaningful comment when committing changes." 1>&2
  echo "----------" 1>&2
  exit 1
fi

# 2- Check that commit message contains more words than $WORD_COUNT_MIN
LOGMSG_WORD_COUNT=$(svnlook log -t "$TXN" "$REPOS" | grep [a-zA-Z0-9] | wc -w)
if [ "$LOGMSG_WORD_COUNT" -lt "$WORD_COUNT_MIN" ] ; then
  echo "----------" 1>&2
  echo "A minimum of $WORD_COUNT_MIN word(s) is required in a log message. You currently have $LOGMSG_WORD_COUNT." 1>&2
  echo "Please provide a meaningful comment when committing changes." 1>&2
  echo "----------" 1>&2
  exit 1
fi

# If we are here, it means that all checks passed, so we can allow the operation to be done.
exit 0

