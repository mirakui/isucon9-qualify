#!/usr/bin/env ruby
require_relative './tmux.rb'

windows = [
  [
    './deploy.sh',
    ['ssh -t isu-app-01', 'sudo journalctl -b -f -u isucari.ruby.service'],
    ['ssh -t isu-app-01', 'sudo watch -n 1 systemctl status isucari.ruby.service'],
    ['ssh -t isu-app-01', 'sudo tail -F /var/log/nginx/error.log'],
    ['ssh -t isu-app-01', 'tail -F /tmp/isu-rack*.log'],
  ],
  [
    ['ssh -t isu-app-01', 'sudo dstat -ltsamp'],
  ]
]

Tmux.run windows
