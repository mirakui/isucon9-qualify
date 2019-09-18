require 'shellwords'
require 'stringio'

module Tmux
  TMUX_CMD = 'tmux'.freeze
  LAYOUT = 'tiled'.freeze
  SESSION_NAME = 'tmux-rb'

  module_function
  def render(windows)
    out = StringIO.new

    out.puts '#!/bin/bash -x'

    out.puts %Q!#{TMUX_CMD} new-session -d -s #{SESSION_NAME}!
    windows.each_with_index do |window, win_id|
      if win_id > 0
        out.puts %Q!#{TMUX_CMD} new-window -t #{SESSION_NAME}!
      end
      window.each_with_index do |cmds, pane_id|
        if pane_id > 0
          out.puts %Q!#{TMUX_CMD} splitw -t #{SESSION_NAME}:#{win_id}!
        end
        cmds = [cmds] unless cmds.is_a?(Array)
        cmds.each do |cmd|
          out.puts %Q!#{TMUX_CMD} send-keys -t #{SESSION_NAME}:#{win_id}.#{pane_id} #{Shellwords.shellescape(cmd)} C-m!
        end
        out.puts %Q!#{TMUX_CMD} select-layout -t #{SESSION_NAME}:#{win_id} #{LAYOUT}!
      end
    end

    out.puts %Q!#{TMUX_CMD} select-window -t #{SESSION_NAME}:0!
    out.puts %Q!#{TMUX_CMD} select-pane -t #{SESSION_NAME}:0.0!
    out.puts %Q!#{TMUX_CMD} -u attach-session -t #{SESSION_NAME}!

    out.string
  end

  def run(windows)
    script = Tmux.render windows
    Kernel.exec script
  end
end
