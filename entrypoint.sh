#!/bin/bash

function get_files {
  files=$(git --no-pager diff --name-only FETCH_HEAD)
}

function get_current_info {
  branch=$(git rev-parse --abbrev-ref HEAD)
  current_branch=${TRIGGER:=$branch}
  echo "Trigger:" $current_branch
}

function prepare_github_info {
  remote=$(git config --get remote.origin.url)
  repo=$(basename $remote .git)
}

# function create_git_tag_and_release {
#   # POST a release to repo via Github API
#   curl -s -X POST https://api.github.com/repos/$REPO_OWNER/$repo/releases \
#   -H "Authorization: token $TOKEN" \
#   -d @- << EOF
#   {
#   "tag_name": "$PREPEND$version_on_file$APPEND",
#   "target_commitish": "$current_branch",
#   "name": "Release $version_on_file",
#   "body": "$release_notes",
#   "draft": $DRAFT,
#   "prerelease": $PRERELEASE
#   }
# EOF
# }

cd $GITHUB_WORKSPACE/

echo "------------- Script Starting ----------------------"

git fetch --prune-tags

get_files

echo $files

if [ -z "$files" ];
then
  echo "Nothing to tag!";
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
  echo $specs
#   result=$(create_git_tag_and_release)
#   echo $result | jq .url
#   exit $?
# fi
echo "------------- Script Ending ----------------------"
