#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

NIX_DIR=$1

allVersions=()
for minorVersion in $(seq 7 14); do
  allVersions+=("2.$minorVersion.0");
done

### Get aggregate stats
printf "Version Range|# Commits|# Pull Requests|# Contributors\n" > release_stats.md

# Double dot vs Triple Dot in git commands
# https://stackoverflow.com/a/24186641/13358239
for idx in $(seq 0 "$(( ${#allVersions[@]} - 2 ))"); do
  prevVersion=${allVersions[$idx]}
  currVersion=${allVersions[$idx + 1]}
  range="$prevVersion - $currVersion"
  commits=$(git -C $NIX_DIR rev-list --no-merges --count $prevVersion..$currVersion)
  pullRequests=$(git -C $NIX_DIR log --oneline $prevVersion..$currVersion | grep 'Merge pull request #' | wc -l)
  numContributors=$(git -C $NIX_DIR shortlog $prevVersion..$currVersion -e -n | rg ":$" | wc -l)
  printf "$range|$commits|$pullRequests|$numContributors\n" >> release_stats.md
done

columnNames=$(head -1 release_stats.md | sed 's/|/,/g' | sed 's/ /_/g')
column --separator "|" -td -N $columnNames -R $columnNames release_stats.md | tee release_stats.md

### Get contributor names
for idx in $(seq 0 "$(( ${#allVersions[@]} - 2 ))"); do
  contributors=$(git -C $NIX_DIR shortlog $prevVersion..$currVersion -e -n | rg ":$")
  prevVersion=${allVersions[$idx]}
  currVersion=${allVersions[$idx + 1]}
  #echo "$contributors"
  echo "$contributors" > "release_${prevVersion}_${currVersion}_contributors.md"

done
