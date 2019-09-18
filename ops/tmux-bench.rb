#!/usr/bin/env ruby
require_relative './tmux.rb'

windows = [
  [
    './bench.sh',
    ['ssh -t isu-app-01', 'sudo tail -F /var/log/nginx/access.log'],
    ['ssh -t isu-app-01', 'sudo tail -F /var/log/nginx/error.log'],
  ],
]

Tmux.run windows
