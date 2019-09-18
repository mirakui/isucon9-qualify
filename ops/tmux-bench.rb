#!/usr/bin/env ruby
require_relative './tmux.rb'

session_name = 'bench'
windows = [
  [
    './bench.sh',
    ['ssh -t isu-app-01', 'sudo tail -F /var/log/nginx/access.log'],
    ['ssh -t isu-app-01', 'sudo tail -F /var/log/nginx/error.log'],
  ],
]

tmux = Tmux.new session_name
tmux.run windows
