#!/bin/bash

org_name=$2
echo "$org_name"
repo_list=`gh repo list $org_name --limit 1000 | awk '{print $1}'`
template_repo=$1
echo "$template_repo"

if [ -z "$template_repo" ]
then
  echo "Usage: $0 <template_repo>"
  echo "  List repositories generated from a given template repository"
  echo "ABORTING!"
  exit 1
fi

echo "$repo_list"
echo "Searching for repositories generated from template: $template_repo"
for repo in $repo_list
do
  repo_info=`gh api repos/$repo`
#  echo "$repo_info"
  echo "$repo_info" | jq -r ".template_repository.full_name" | grep "$template_repo" 2>&1 > /dev/null
  if [ "$?" -eq "0" ]
  then
    echo "repo_using_template: $repo"
  fi
done