#!/bin/bash

#AREA=europe
#IDENTITYDOMAIN=gse00002265
#USER=cloud.admin
#PASSWD=gReEDy@1Blow
#
#psm setup

APP_STATUS_RUNNING="RUNNING"


JOB_STATUS_RUNNING="RUNNING"
JOB_STATUS_SUCCEED="SUCCEED"

APP_NAME=EmployeeWebApp
APP_ARCHIVE_PATH=employees-web-app.zip
APP_ARCHIVE_URL=target/EmployeeRESTApp-1.0-dist.zip #本番テストはURLを使う

echo APP_NAME:$APP_NAME

# | grep "Status:" | grep "RUNNING"

# psm accs app -n ${APP_NAME} -of short

app_status=$(psm accs app -n $APP_NAME -of short | grep 'Status:' | awk '{print $2}')

echo app_status:$app_status 

if [ -n "$app_status" ]; then
  echo "APP: " $APP_NAME "が存在していません。"
else
  echo "APP: " $APP_NAME "が既に存在しています。"
fi

accs_push_jobid=$(psm accs push -n $APP_NAME -r java -s monthly -d deployment.json -u $APP_ARCHIVE_URL -of short | grep 'Job ID:' | awk '{print $3}')  #本番テストはURLを使う

echo accs_push_jobid:$accs_push_jobid 

echo "APP: " $APP_NAME "を登録しています。"
accs_push_status=$JOB_STATUS_RUNNING
while [ $accs_push_status == $JOB_STATUS_RUNNING ]
do
    accs_push_status=$(psm accs operation-status -j $accs_push_jobid -of short | grep 'Status:' | awk '{print $2}')
	echo .
	sleep 10
done

if [ $accs_push_status == $JOB_STATUS_SUCCEED ]
then
  echo "APP: " $APP_NAME "の登録が正常に終了しました。"
else
  echo "APP: " $APP_NAME "の登録が異常に終了しました。"
fi

# DBCS インスタンス登録＆アクセスルールora_p2_dblistener略


