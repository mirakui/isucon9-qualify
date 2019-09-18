#!/usr/bin/env ruby
require_relative './tmux.rb'

session_name = 'deploy'
windows = [
  [
    './deploy.sh',
    ['ssh isu-app-01', 'sudo journalctl -b -f -u isucari.ruby.service'],
    ['ssh isu-app-01', 'sudo watch -n 1 systemctl status isucari.ruby.service'],
    ['ssh isu-app-01', 'sudo tail -F /var/log/nginx/error.log'],
    ['ssh isu-app-01', 'tail -F /tmp/isu-rack*.log'],
  ],
  [
    ['ssh isu-app-01', 'sudo dstat -ltsamp'],
  ]
]

tmux = Tmux.new session_name
tmux.run windows
