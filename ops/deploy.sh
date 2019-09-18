#!/bin/bash -x

TARGET_HOST=10.0.0.212

ssh -T isu-app-01 << EOSSH
set -x
cd /home/isucon/git
git pull origin master
cd /home/isucon/git/webapp/ruby
/home/isucon/ruby/bin/bundle install --path=.bundle
sudo cp /home/isucon/git/nginx.conf /etc/nginx/nginx.conf

sudo bash -c '
echo > /var/log/nginx/access.log;
echo > /var/log/nginx/error.log;
echo > /var/lib/mysql/mysql-slow.log;
'
echo > /tmp/isu-rack.log
echo > /tmp/isu-rack.systemd.log

sudo systemctl restart isucari.ruby.service
sudo nginx -t
sudo nginx -s reload
EOSSH
