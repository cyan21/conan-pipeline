#!/bin/bash

usage()
{
  echo "=============================================================="
  echo -e "Usage:\n\t $0 -p PROFILE -a CREATE_CMD_ARGS -f PATH_TO_RECIPE [-h]"
  echo -e "==============================================================\n"
  exit 2
}

args=""

while getopts 'hp:a:f:i:n' c
do
  case $c in
    p) profile=$OPTARG ;;
    a) args=$OPTARG ;;
    f) filepath=$OPTARG ;;
    i) build_id=$OPTARG ;;
    n) build_num=$OPTARG ;;
    h) usage ;;
  esac
done

pushd .

cd $filepath 

# get dependency tree with versions
conan graph lock -p ${profile} .

# set Build Info properties
conan_build_info --v2 start $build_id $build_num

conan profile update settings.compiler.libcxx=libstdc++11 $profile 
conan create  -p $profile $args --lockfile . --ignore-dirty . mycompany/stable

pwd && ls -l 

popd
