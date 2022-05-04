#!/usr/bin/env bash

APP_BASE=$(pwd)/TechChallengeApp

sudo yum -y install git
sudo yum -y install go


if [ -d $APP_BASE ]; then
        sudo rm -rf $APP_BASE
fi

git clone https://github.com/mmayub/TechChallengeApp.git

# build app
cd $APP_BASE && go get

#getting rice tool
go get github.com/GeertJohan/go.rice
go get github.com/GeertJohan/go.rice/rice

sudo ./build.sh

# create database and seed with data
cd $APP_BASE/dist/ && sudo ./TechChallengeApp updatedb -s

# add crontab entry to start app if server restarts
crontab<<EOF
@reboot cd $APP_BASE/dist/ && sudo ./TechChallengeApp serve
EOF

# start app
cd $APP_BASE/dist/ && sudo ./TechChallengeApp serve
