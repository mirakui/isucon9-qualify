#!/usr/bin/env ruby
require_relative './tmux.rb'

session_name = 'bench'
windows = [
  [
    './bench.sh',
  ],
  [
    ['ssh isu-app-01', 'sudo less +F -S /var/log/nginx/access.log'],
  ],
  [
    ['ssh isu-app-01', 'sudo less +F /var/lib/mysql/mysql-slow.log'],
  ],
  [
    ['ssh isu-app-01', 'sudo less +F /var/log/mysql/error.log'],
    ['ssh isu-app-01', 'sudo less +F /var/log/nginx/error.log'],
    ['ssh isu-app-01', 'less +F /tmp/isu-rack.log'],
    ['ssh isu-app-01', 'less +F /tmp/isu-rack.systemd.log'],
  ],
]

tmux = Tmux.new session_name
tmux.run windows
