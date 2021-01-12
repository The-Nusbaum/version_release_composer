#!/bin/bash

function get_files {
  files=$(git --no-pager diff --name-only FETCH_HEAD)
}

cd $GITHUB_WORKSPACE/

echo "------------- Script Starting ----------------------"

git fetch --prune-tags

get_files

echo $files

if [ -z "$files" ];
then
  echo "Nothing Found";
  exit $?
else
  echo "Files found, iterating for *.spec files"
  specs=0
  export IFS=" "
  for file in $files; do
    if [[ $file =~ .*\.spec ]]; then
      specs=$(($specs++))
    fi
  done
  if [[ $specs = 0 ]]; then
    echo "No spec files found."
    exit 1
  else
    echo "Spec files found"
    exit 0
  fi
fi
echo "------------- Script Ending ----------------------"
