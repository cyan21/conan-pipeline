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

ls ${CONAN_USER_HOME}.conan/artifacts.properties && cat $CONAN_USER_HOME/artifacts.properties

# get dependency tree with versions
conan graph lock -p ${profile} .

conan profile update settings.compiler.libcxx=libstdc++11 $profile 
conan create  -p $profile $args --lockfile . --ignore-dirty . mycompany/stable

pwd && ls -l 

popd
