#!/bin/bash

#psm setupパラメータ
USERNAME="cloud.admin"
PASSWORD="gReEDy@1Blow"
IDENTITY_DOMAIN="gse00002265"
REGION="emea"
OUTPUT_FORMAT="short"

echo ">>>Start Build.sh ...<<<"
	pwd
	ls -a
	

APP_STATUS_RUNNING="RUNNING" #psm setup引数
JOB_STATUS_RUNNING="RUNNING"
JOB_STATUS_SUCCEED="SUCCEED"
APP_NAME=EmployeeWebApp
APP_ARCHIVE_PATH=employees-web-app.zip
APP_ARCHIVE_URL=../target/EmployeeRESTApp-1.0-dist.zip # 本番テストはURLを使う

echo APP_NAME:$APP_NAME

#psm setup
psm help

psm -v

echo -e "$USERNAME\n$PASSWORD\n$PASSWORD\n$IDENTITY_DOMAIN\n$REGION\n$OUTPUT_FORMAT" | psm setup

psm help


echo ">>>Start psm 1...<<<"
psm accs app -n $APP_NAME -of short
echo ">>>End psm 1...<<<"
app_status=$(psm accs app -n $APP_NAME -of short | grep 'Status:' | awk '{print $2}')

echo app_status:$app_status 

if [ -n "$app_status" ]; then
  echo "APP: " $APP_NAME "が存在していません。"
else
  echo "APP: " $APP_NAME "が既に存在しています。"
fi
echo ">>>Start psm 2...<<<"
accs_push_jobid=$(psm accs push -n $APP_NAME -r java -s monthly -d deployment.json -u $APP_ARCHIVE_URL -of short | grep 'Job ID:' | awk '{print $3}')  # 本番テストはURLを使う
echo ">>>End psm 2...<<<"

echo accs_push_jobid:$accs_push_jobid 

echo "APP: " $APP_NAME "を登録しています。"
accs_push_status=$JOB_STATUS_RUNNING
while [ "$accs_push_status" == "$JOB_STATUS_RUNNING" ]
do
    accs_push_status=$(psm accs operation-status -j $accs_push_jobid -of short | grep 'Status:' | awk '{print $2}')
	echo .
	sleep 10
done

if [ "$accs_push_status" == "$JOB_STATUS_SUCCEED" ]
then
  echo "APP: " $APP_NAME "の登録が正常に終了しました。"
else
  echo "APP: " $APP_NAME "の登録が異常に終了しました。"
fi

# DBCS インスタンス登録＆アクセスルールora_p2_dblistener略


