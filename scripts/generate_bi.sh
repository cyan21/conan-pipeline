#!/bin/bash

usage()
{
  echo "=============================================================="
  echo -e "Usage:\n\t $0 -u ART_USER -k ART_APIKEY -l LOCKFILE_PATH -i BUILD_ID -n BUILD_NUMBER -o <OUTPUT_JSON_FILE> [-h]"
  echo -e "==============================================================\n"
  exit 2
}

lockfile_path="."

while getopts 'hu:k:l:i:n:o:' c
do
  case $c in
    u) art_user=$OPTARG ;;
    k) art_apikey=$OPTARG ;;
    l) lockfile_path=$OPTARG ;;
    i) build_id=$OPTARG ;;
    n) build_num=$OPTARG ;;
    o) output_file=$OPTARG ;;
    h) usage ;;
  esac
done

# set Build Info properties
#conan_build_info --v2 start $build_id $build_num

# generate build info
echo "conan_build_info --v2 create --lockfile $lockfile_path/conan.lock --user $art_user --password $art_apikey ${output_file}"
conan_build_info --v2 create ${output_file} --lockfile $lockfile_path/conan.lock --user $art_user --password $art_apikey 
cat ${output_file}                        

# remove Build Info props
conan_build_info --v2 stop

