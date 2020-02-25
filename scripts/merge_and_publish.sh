#!/bin/bash

usage()
{
  echo "=============================================================="
  echo -e "Usage:\n\t $0 -a ART_URL -u ART_USER -k ART_APIKEY -i BUILD_ID [-h]"
  echo -e "==============================================================\n"
  exit 2
}

while getopts 'ha:u:k:i:' c
do
  case $c in
    a) art_url=$OPTARG ;;
    u) art_user=$OPTARG ;;
    k) art_apikey=$OPTARG ;;
    i) build_id=$OPTARG ;;
    h) usage ;;
  esac
done

#rm -f ${build_id}.json 

#for i in `ls *${build_id}.json`; do echo $i; cat $i; done

# generate build info
#conan_build_info --v2 update --output-file ${build_id}.json $(ls *${build_id}.json)

cat ${build_id}.json

# publish build info
conan_build_info --v2 publish ${build_id}.json --url $art_url --user $art_user --password $art_apikey
