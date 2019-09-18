require 'shellwords'
require 'stringio'

class Tmux
  TMUX_CMD = 'tmux'.freeze
  LAYOUT = 'tiled'.freeze
  DEFAULT_SESSION_NAME = 'tmux-rb'.freeze

  def initialize(session_name=nil)
    @session_name = session_name || DEFAULT_SESSION_NAME
  end

  def render(windows)
    out = StringIO.new

    out.puts '#!/bin/bash -x'

    out.puts %Q!#{TMUX_CMD} new-session -d -s #{@session_name}!
    windows.each_with_index do |window, win_id|
      if win_id > 0
        out.puts %Q!#{TMUX_CMD} new-window -t #{@session_name}!
      end
      window.each_with_index do |cmds, pane_id|
        if pane_id > 0
          out.puts %Q!#{TMUX_CMD} splitw -t #{@session_name}:#{win_id}!
        end
        cmds = [cmds] unless cmds.is_a?(Array)
        cmds.each do |cmd|
          out.puts %Q!#{TMUX_CMD} send-keys -t #{@session_name}:#{win_id}.#{pane_id} #{Shellwords.shellescape(cmd)} C-m!
        end
        out.puts %Q!#{TMUX_CMD} select-layout -t #{@session_name}:#{win_id} #{LAYOUT}!
      end
    end

    out.puts %Q!#{TMUX_CMD} select-window -t #{@session_name}:0!
    out.puts %Q!#{TMUX_CMD} select-pane -t #{@session_name}:0.0!
    out.puts %Q!#{TMUX_CMD} -u attach-session -t #{@session_name}!

    out.string
  end

  def run(windows)
    script = render windows
    Kernel.exec script
  end
end
