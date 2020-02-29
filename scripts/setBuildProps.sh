#!/bin/sh

cli_path="./"

usage()
{
  echo "=============================================================="
  echo -e "Usage:\n\t $0 -r repo -l lockfile -i BUILD_ID -n BUILD_NUMBER [-h]"
  echo -e "==============================================================\n"
  exit 2
}

while getopts 'hl:i:n:r:' c
do
  case $c in
    l) lockfile=$OPTARG ;;
    i) build_id=$OPTARG ;;
    n) build_num=$OPTARG ;;
    r) repo=$OPTARG ;;
    h) usage ;;
  esac
done

# it seems .graph_lock.nodes.0 is forbidden an throws an error => hence the sed
# reference = <PACKAGE_NAME>/<PACKAGE_VERSION>@<USER>/<CHANNEL>#<RREV>:<PACKAGE_ID>#<PREV>
reference=`sed s/"0"/"zero"/ $lockfile | jq .graph_lock.nodes.zero.pref | tr -d '"' | sed s/zero/0/`
#echo $reference

repo_path=$(echo $reference | sed s/@[a-z]*// | cut -d: -f1 | sed s/#/\\//)
user=$(echo $reference | cut -d@ -f2 | cut -d/ -f1)
path_prev=$(echo $reference | cut -d: -f2 | sed s/#/\\//)

# target revision export folder
echo "[INFO] setting up build properties ..."

#echo "jfrog rt sp ${repo}/${user}/${repo_path}/export/ \"build.name=$build_id;build.number=$build_num\" "
${cli_path}/jfrog rt sp ${repo}/${user}/${repo_path}/export/ "build.name=$build_id;build.number=$build_num"
echo "[INFO] Build properties succesfully applied to the export folder "

# target package revision
#echo "jfrog rt sp --exclude-patterns=\".timestamp\" ${repo}/${user}/${repo_path}/package/${path_prev} \"build.name=$build_id;build.number=$build_num\"" 

${cli_path}/jfrog rt sp --exclude-patterns=".timestamp" ${repo}/${user}/${repo_path}/package/${path_prev}/ "build.name=$build_id;build.number=$build_num" 
echo "[INFO] Build properties succesfully applied to the package revision"
