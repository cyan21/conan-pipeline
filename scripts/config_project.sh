#!/bin/bash

usage()
{
  echo "=============================================================="
  echo -e "Usage:\n\t $0 -c CONFIG_URL -a ART_URL -u ART_USER -k ART_APIKEY -r ART_REPO -i BUILD_ID -n BUILD_NUMBER [-h]"
  echo -e "==============================================================\n"
  exit 2
}

while getopts 'hc:a:u:k:r:i:n:' c
do
  case $c in
    c) config_url=$OPTARG ;;
    a) art_url=$OPTARG ;;
    u) art_user=$OPTARG ;;
    k) art_apikey=$OPTARG ;;
    r) art_repo=$OPTARG ;;
    i) build_id=$OPTARG ;;
    n) build_num=$OPTARG ;;
    h) usage ;;
  esac
done

# install remote, profiles, global conf
conan config install config 
                      
conan profile list 

# configure access to Artifactory 
conan remote add $art_repo "${art_url}/api/conan/${art_repo}"
conan user -p $art_apikey -r $art_repo $art_user

# set Build Info properties
conan_build_info --v2 start $build_id $build_num

ls $CONAN_USER_HOME/artifacts.properties && cat $CONAN_USER_HOME/artifacts.properties
