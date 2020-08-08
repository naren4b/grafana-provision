#!/bin/bash
# ./transfer-grafana-http <source_host-grafana-ip> <target_host-grafana-ip> <folder_uid> <dashboard_uid> <folderTitle> <folderUrl>
set -e
jq --version >/dev/null 2>&1 || { echo >&2 "I require jq but it's not installed.  Aborting."; exit 1; }

source_host=$1
sourceurl="http://admin:admin@$source_host:3000"

target_host=$2
targeturl="http://admin:admin@$target_host:3000"

folder_uid=$3
dashboard_uid=$4
folderTitle=$5
folderUrl=$6

function getDashboard(){
    logme "info" "getDashboard :: "$url
	uid=$dashboard_uid
	echo "dashboard: "$(curl -s $url/api/dashboards/uid/$uid | jq '.')
	
}

function getFolder(){
    logme "info" "getFolder :: "$url
	uid=$folder_uid
	folder=$(curl -s $url/api/folders/$uid)
	echo "folder uid: "$(echo $folder | jq '.')
	
}



function transfer(){
  logme "info" "transfer :: "
  url=$1
  checkAndCreateFolder   $url $folder_uid
  checkAndCreateDashboard $url $dashboard_uid   
}

function checkAndCreateFolder(){
	logme "info" "checkAndCreateFolder:: "
	folder=$(curl $destination_grafana_host/api/folders/folder_uid | jq '.id')
	if [ -z "$folder" ] ; then
	  echo "Didn't get folder $folder_uid" ; 
	  createFolder $url $folder_uid
	else 
	  echo "Folder exist" ;
	fi
}

function checkAndCreateDashboard(){
	logme "info" "checkAndCreateDashboard:: "
	dashboard=$(curl -s $url/api/dashboards/uid/$dashboard_uid | jq '.dashboard.uid')
	if [ -z "$dashboard" ] ; then
	  echo "Didn't get dashboard $dashboard" ;  
	else 
	  echo "Dashboard exist" ;
	  deleteDashboard $url $dashboard_uid
	fi
	createDashboard $url $dashboard_uid
}

function deleteDashboard(){
    logme "info" "deleteDashboard :: "
	url=$1
	uid=$2
	echo "Delete the dashboard "$uid
	curl -s -XDELETE $url/api/dashboards/uid/$uid
	echo "Dashboard deleted "
}

function createFolder(){
  logme "info" "createFolder:: "
  url=$1
  uid=$2
  target_folder_json=$(curl -s $sourceurl/api/folders/$uid)
  
  target_folder_json=$(echo $target_folder_json | jq '.id=null') 
  echo "replaced id to null"
  
  echo "============================="
  echo "$target_folder_json"
  echo "============================="
  
  curl -s -XPOST -H "Accept: application/json" \
     -H "Content-Type: application/json" \
     -d "$target_folder_json" \
     $url/api/folders; 
}


function createDashboard(){
  logme "info" "createDashboard :: "
  url=$1
  
  folderId=$(curl -s $url/api/folders/$folder_uid | jq '.id'  )
  echo "folderId "$folderId 

  target_dashboard_json=$(curl -s $sourceurl/api/dashboards/uid/$dashboard_uid)

  target_dashboard_json=$(echo $target_dashboard_json | jq '.dashboard.id=null')
  echo "replaced id to null"

  target_dashboard_json=$(echo $target_dashboard_json | jq --arg id "$folderId" '.meta.folderId=$id')
  echo "replaced the folder id"

  target_dashboard_json=$(echo $target_dashboard_json | jq --arg title "$folderTitle" '.meta.folderTitle=$title')
  echo "replaced the folder title"

  target_dashboard_json=$(echo $target_dashboard_json | jq --arg fUrl "$folderUrl" '.meta.folderUrl=$fUrl')
  
  echo $target_dashboard_json > my_dashboard.json
  
  echo "============================="
  echo "$target_dashboard_json"
  echo "============================="
  
  curl -s -XPOST -H "Accept: application/json" \
     -H "Content-Type: application/json" \
     -d "$target_dashboard_json" \
     $url/api/dashboards/db; 
  
}


function printDetails(){
  logme "info" "printDetails :: "
  url=$1
  getFolder $url $folder_uid
  getDashboard $url $dashboard_uid

}

function main()
{
   logme "info" "Start the Script:: "
   logme "info" "Target >>>>>>>>>>>>>>>>>>> "
   printDetails $targeturl
   logme "info" "Source >>>>>>>>>>>>>>>>>>> "
   printDetails $sourceurl
   logme "info" "TARNSFER >>>>>>>>>>>>>>>>>>"
   transfer $targeturl
   
}

function logme()
{ 
   NC="\033[0m"
   case $1 in 
    "err") COLOR="\e[31m";;
	"info") COLOR="\033[0;32m";;
	"*") COLOR="\033[0m";;
   esac
   echo -e "${COLOR} $2 ${NC}"  
   
}

main

