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
APP_NAME=EmployeeWebApp #アプリケーションの名称
APP_ARCHIVE_URL=../target/EmployeeRESTApp-1.0-dist.zip  #アプリケーションの格納場所

echo APP_NAME:$APP_NAME


if [ -e $APP_ARCHIVE_URL ]; then
    # 存在する場合
	echo $APP_ARCHIVE_URL "が存在しています。"
else
    # 存在しない場合
	echo $APP_ARCHIVE_URL "が存在していません。"
fi

if [ -e deployment.json ]; then
    # 存在する場合
	echo "deployment.json が存在しています。"
else
    # 存在しない場合
	echo "deployment.json が存在していません。"
fi

#psm setup実行
psm help
psm -v
echo -e "$USERNAME\n$PASSWORD\n$PASSWORD\n$IDENTITY_DOMAIN\n$REGION\n$OUTPUT_FORMAT" | psm setup
psm help

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
echo "ACCSアプリケーションのデプロイを実行します...1"
psm accs push -n $APP_NAME -r java -s monthly -d deployment.json -u $APP_ARCHIVE_URL -of short

echo "ACCSアプリケーションのデプロイを実行します...2"
accs_push_jobid=$(psm accs push -n $APP_NAME -r java -s monthly -d deployment.json -u $APP_ARCHIVE_URL -of short | grep 'Job ID:' | awk '{print $3}')  # 本番テストはURLを使う

echo accs_push_jobid:$accs_push_jobid 


echo "deploy.sh が終了しました。"
