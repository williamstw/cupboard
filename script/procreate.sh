#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

: <<DOCUMENTATION
 -----------------------------------------------
| procreate.sh 
 -----------------------------------------------
 A utility to create a starting point for a decent
 bash script - doing what should be done.

 -f  name of script to be create (destructive)
 -h  print this message

 NOTE: Modify this documentation for your own script.
 ----------------------------------------------
DOCUMENTATION

function usage { 
 echo "Usage: $0 [-f <filename] -h" 
 exit 1 
}
scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function cleanup {
 rm -rf $scratch
 # Custom cleanup code here.
}
trap cleanup EXIT

### Provide some execution context
bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

### Fail on any non-zero return codes
set -e
### Fail on unset variables
set -u
### Fail pipelines if pipe fails
set -o pipefail

### Use tabs, newlines for Field Separator
IFS=$'\n\t'

EXPECTED_ARGS=":f:h"
set +u

OPT_FILENAME=""

while getopts "${EXPECTED_ARGS}" opt; do
  case $opt in 
     f)
      OPT_FILENAME="$OPTARG"     
      ;;
     h)
       usage
      ;;
     \?)
      echo "Invalid option: -$OPTARG" >&2
      ;; 
     
   esac
done
set -u  

#___functions


#___main

### Mac oddities: 
###    o) lack of head -n <negativenums>
###    o) lack of associative array declarations
LC=$(cat $0 | grep -v ^### | uniq | wc -l)
COUNT=$(($LC-7))

if [ ! "${OPT_FILENAME}" == "" ]; then
  cat $0 | grep -v ^### | uniq | awk -v C=$COUNT '{ if ( NR < C ) print $0 }' > ${OPT_FILENAME}
else
  cat $0 | grep -v ^### | uniq | awk -v C=$COUNT '{ if ( NR < C ) print $0 }'
fi
