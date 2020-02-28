#!/bin/bash

usage()
{
  echo "=============================================================="
  echo -e "Usage:\n\t $0 -u ART_USER -k ART_APIKEY -l LOCKFILE_PATH -o <OUTPUT_JSON_FILE> [-h]"
  echo -e "==============================================================\n"
  exit 2
}

lockfile_path="."

while getopts 'hu:k:l:o:' c
do
  case $c in
    u) art_user=$OPTARG ;;
    k) art_apikey=$OPTARG ;;
    l) lockfile_path=$OPTARG ;;
    o) output_file=$OPTARG ;;
    h) usage ;;
  esac
done


# generate build info
conan_build_info --v2 create ${output_file} --lockfile $lockfile_path/conan.lock --user $art_user --password $art_apikey 
cat ${output_file}                        

# remove Build Info props
#conan_build_info --v2 stop

