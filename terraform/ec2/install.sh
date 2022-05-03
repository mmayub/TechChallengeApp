#!/usr/bin/env bash

sudo yum -y install git
sudo yum -y install go
git clone https://github.com/mmayub/TechChallengeApp.git

# build app
cd /TechChallengeApp/ && sudo ./build.sh
# create database and seed with data
cd /TechChallengeApp/dist/ && sudo ./TechChallengeApp updatedb

# add crontab entry to start app if server restarts
crontab<<EOF
@reboot cd /TechChallengeApp/dist/ && sudo ./TechChallengeApp serve
EOF

# start app
cd /TechChallengeApp/dist/ && sudo ./TechChallengeApp serve