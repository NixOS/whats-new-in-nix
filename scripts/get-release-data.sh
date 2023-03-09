#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-C <path>] [-f <int>] [-l <int>]

Get release statistics for the NixOS/nix repo.

You want to run this on the NixOS/nix repo so either copy the script over or
use the -C/--path parameter.

Available options:

-h, --help      Print this help and exit
-C, --path      Path to run this script on. Default is current directory.
-f, --first     First minor version to include. Default 7.
-l, --last      Last minor version to include. Default 14.
EOF
  exit
}

parsedArgs=$(getopt --options hC:f:l: --longoptions help,path:,first:,last: -- "$@")
validArgs=$?
if [ "$validArgs" != "0" ]; then
  usage
fi

nixDir=$PWD
firstMinor=7
lastMinor=14

eval set -- "$parsedArgs"
while true; do
    case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        -C | --path)
            nixDir="$2";
            shift 2
            ;;
        -f | --first)
            firstMinor="$2";
            shift 2
            ;;
        -l | --last)
            lastMinor="$2";
            shift 2
            ;;
        --)
            shift;
            break
            ;;
        *)
            echo "Unexpected option: $1 - this should not happen."
            exit 1
            ;;
    esac
done

allVersions=()
for minorVersion in $(seq $firstMinor $lastMinor); do
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
  commits=$(git -C $nixDir rev-list --no-merges --count $prevVersion..$currVersion)
  pullRequests=$(git -C $nixDir log --oneline $prevVersion..$currVersion | grep 'Merge pull request #' | wc -l)
  numContributors=$(git -C $nixDir shortlog $prevVersion..$currVersion -e -n | rg ":$" | wc -l)
  printf "$range|$commits|$pullRequests|$numContributors\n" >> release_stats.md
done

columnNames=$(head -1 release_stats.md | sed 's/|/,/g' | sed 's/ /_/g')
column --separator "|" -td -N $columnNames -R $columnNames release_stats.md | tee release_stats.md

### Get contributor names
for idx in $(seq 0 "$(( ${#allVersions[@]} - 2 ))"); do
  contributors=$(git -C $nixDir shortlog $prevVersion..$currVersion -e -n | rg ":$")
  prevVersion=${allVersions[$idx]}
  currVersion=${allVersions[$idx + 1]}
  #echo "$contributors"
  echo "$contributors" > "release_${prevVersion}_${currVersion}_contributors.md"

done
