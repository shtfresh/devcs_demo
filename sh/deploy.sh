#!/bin/bash

#psm setupパラメータ
USERNAME="cloud.admin"
PASSWORD="gReEDy@1Blow"
IDENTITY_DOMAIN="gse00002265"
REGION="emea"
OUTPUT_FORMAT="short"

echo "deploy.sh を開始します..."

APP_STATUS_RUNNING="RUNNING" #アプリケーションの状態
JOB_STATUS_RUNNING="RUNNING" #ジョブの状態
JOB_STATUS_SUCCEED="SUCCEED" #ジョブの状態
APP_NAME="EmployeeWebApp" #アプリケーションの名称

#==================
APP_ARCHIVE_NAME="EmployeeRESTApp-1.0-dist.zip"  #archive名称
APP_ARCHIVE_PATH="../target/EmployeeRESTApp-1.0-dist.zip"  #archiveの格納場所（DevCS）

STORAGE_CONTAINER=FirstDemoContainer #archiveを格納するstorage container名
REST_URL=https://em2.storage.oraclecloud.com  #storage cloudのURL
#==================

#==================
if [ -e $APP_ARCHIVE_PATH ]; then
    # 存在する場合
	echo $APP_ARCHIVE_PATH "が存在しています。"
else
    # 存在しない場合
	echo $APP_ARCHIVE_PATH "が存在していません。"
	exit 0
fi
#==================
echo APP_NAME:$APP_NAME


#==================
#upload実行
token=`curl -v -s -X GET -H "X-Storage-User: Storage-$IDENTITY_DOMAIN:$USERNAME" -H "X-Storage-Pass: $PASSWORD" $REST_URL/auth/v1.0 |& grep X-Auth-Token | awk -F' ' '{print $3}'`

curl -v -X PUT \
     -H "X-Auth-Token: $token" \
     -T $APP_ARCHIVE_PATH \
     $REST_URL/v1/Storage-$IDENTITY_DOMAIN/$STORAGE_CONTAINER/$APP_ARCHIVE_NAME
#==================

#psm setup実行
psm -v
echo -e "$USERNAME\n$PASSWORD\n$PASSWORD\n$IDENTITY_DOMAIN\n$REGION\n$OUTPUT_FORMAT" | psm setup

#ACCSアプリケーション存在チェック実行
echo "ACCSアプリケーション存在チェックを実行します..."
psm accs app -n $APP_NAME -of short
app_status=$(psm accs app -n $APP_NAME -of short | grep 'Status:' | awk '{print $2}')

echo app_status:$app_status 

if [ -n "$app_status" ]; then
  echo "APP: " $APP_NAME "が既に存在しています。"
else
  echo "APP: " $APP_NAME "が存在していません。"
fi

#ACCSアプリケーションのデプロイ実行
echo "ACCSアプリケーションのデプロイを実行します..."
accs_push_jobid=$(psm accs push -n $APP_NAME -r java -s monthly -d deployment.json -u $STORAGE_CONTAINER/$APP_ARCHIVE_NAME -of short | grep 'Job ID:' | awk '{print $3}')

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

echo "deploy.sh が終了しました。"
