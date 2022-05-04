# this script is used to set up db and run the app
# this will run as part of instance launch when the instance is first launched in aws
# install.sh is passed as user_data in launch configuration
#!/usr/bin/env bash

sudo yum -y install git
sudo yum -y install go
git clone https://github.com/mmayub/TechChallengeApp.git

# build app
cd /TechChallengeApp/

#getting rice tool
go get github.com/GeertJohan/go.rice
go get github.com/GeertJohan/go.rice/rice

sudo ./build.sh
# create database and seed with data
cd /TechChallengeApp/dist/ && sudo ./TechChallengeApp updatedb

# add crontab entry to start app if server restarts
crontab<<EOF
@reboot cd /TechChallengeApp/dist/ && sudo ./TechChallengeApp serve
EOF

# start app
cd /TechChallengeApp/dist/ && sudo ./TechChallengeApp serve