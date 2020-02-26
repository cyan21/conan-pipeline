#!/bin/bash

usage()
{
  echo "=============================================================="
  echo -e "Usage:\n\t $0 -a ART_URL -k ART_APIKEY -r ART_REPO -p PROFILE -u UPLOAD_REGEX -l LOCKFILE_PATH -f PATH_TO_RECIPE  [-h]"
  echo -e "==============================================================\n"
  exit 2
}

lockfile_path="."

while getopts 'ha:k:r:p:u:l:f:' c
do
  case $c in
    a) art_url=$OPTARG ;;
    k) art_apikey=$OPTARG ;;
    r) art_repo=$OPTARG ;;
    u) regex=$OPTARG ;;
    p) profile=$OPTARG ;;
    l) lockfile_path=$OPTARG ;;
    f) filepath=$OPTARG ;;
    h) usage ;;
  esac
done

pushd .

cd $filepath 

conan upload "$regex" --all -r $art_repo --confirm --force

#name=$(conan inspect . --raw name)
#version=$(conan inspect . --raw version)

#fullurl="$art_url/$art_repo/$name/$version/$profile/conan.lock"

#curl -H "X-JFrog-Art-Api:${art_apikey}" -XPUT -T $lockfile_path/conan.lock "$fullurl"

popd
