#!/bin/bash

usage()
{
  echo "=============================================================="
  echo -e "Usage:\n\t $0 -c CONFIG_URL -a ART_URL -u ART_USER -k ART_APIKEY -r ART_REPO [-h]"
  echo -e "==============================================================\n"
  exit 2
}

while getopts 'hc:a:u:k:r:' c
do
  case $c in
    c) config_url=$OPTARG ;;
    a) art_url=$OPTARG ;;
    u) art_user=$OPTARG ;;
    k) art_apikey=$OPTARG ;;
    r) art_repo=$OPTARG ;;
    h) usage ;;
  esac
done

# install remote, profiles, global conf
conan config install config 
                      
conan profile list 

# configure access to Artifactory 
conan remote add $art_repo "${art_url}/api/conan/${art_repo}"
conan user -p $art_apikey -r $art_repo $art_user

conan profile update settings.compiler.libcxx=libstdc++11 default
