#!/bin/bash -x

TARGET_HOST=10.0.0.212

ssh -T isu-app-01 << EOSSH
set -x
cd /home/isucon/src/isucon9-qualify
git pull origin master
rsync -avz /home/isucon/src/isucon9-qualify/webapp/ruby/ /home/isucon/isucari/webapp/ruby/
sudo systemctl restart isucari.ruby.service
sudo systemctl restart nginx.service
sudo systemctl status nginx.service isucari.ruby.service
EOSSH
