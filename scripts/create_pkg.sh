#!/bin/bash

usage()
{
  echo "=============================================================="
  echo -e "Usage:\n\t $0 -p PROFILE -a CREATE_CMD_ARGS -f PATH_TO_RECIPE [-h]"
  echo -e "==============================================================\n"
  exit 2
}

args=""

while getopts 'hp:a:f:' c
do
  case $c in
    p) profile=$OPTARG ;;
    a) args=$OPTARG ;;
    f) filepath=$OPTARG ;;
    h) usage ;;
  esac
done

pushd .

cd $filepath 

# get dependency tree with versions
#conan graph lock -p ${profile} .

conan profile update settings.compiler.libcxx=libstdc++11 $profile 
conan create  -l conan.lock -p $profile $args --ignore-dirty . mycompany/stable
#conan create -p $profile $args --ignore-dirty . mycompany/stable                   

popd
