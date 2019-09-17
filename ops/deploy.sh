#!/bin/bash -x

TARGET_HOST=10.0.0.212

ssh -T isu-app-01 << EOSSH
set -x
cd /home/isucon/git
git pull origin master
cd /home/isucon/git/webapp/ruby
bundle
sudo cp /home/isucon/git/nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart isucari.ruby.service
sudo nginx -t
sudo nginx -s reload
EOSSH
