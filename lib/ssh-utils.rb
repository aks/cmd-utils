# ssh-utils.rb
#
# A module to define some routines for running commands across many systems
# using ssh
#
# Copyright 2013-2015, Alan K. Stebbens <aks@stebbens.org>
#
# Usage:
#
#    require 'ssh-utils'
#
#    on SERVERLIST, :debug = true do |server|
#      as USER do
#        with PATH do
#          remote_run :whoami
#        end
#      end
#    end

require 'rubygems'
require 'talk-utils'

module SSH_Utils

  attr_reader   :server
  attr_accessor :servers

  @opts = {}
  @opts.default = nil
  @@default_envars = %w(PATH)			# default envarlist

  def merge_opts opts = {}
    @opts ||= {}
    @opts.merge!(opts) unless opts.empty?
  end

  # merge_env opts
  #
  # merge envars.  :with => ENVARS_TO_ADD, :without => ENVARS_TO_EXCLUDE
  #   :with => %w(PATH RUBYLIB)
  #   :without => %w(PATH)
  # Removes the :with and :without keys from the opts hash

  def merge_env opts
    @envars = @@default_envars
    if opts.key?(:with)
      @envars.concat(opts[:with]).uniq!
      opts.delete(:with)
    end
    if opts.key?(:without)
      @envars -= opts[:without]
      opts.delete(:without)
    end
  end

  # merge_opts_with_env opts
  #
  # Invokes merge_env, then merge_opts

  def merge_opts_with_env opts = {}
    merge_env (opts = opts.dup)
    merge_opts opts
  end

  # on SERVERLIST, :with => %w(PATH RUBYLIB), :debug => [true|false], :norun => [true|false]

  def on servers, opts = {}
    merge_opts_with_env opts
    (@servers = servers).each do |server|
      @server = server
      talk("--> Running block for server #{server}..") if @opts[:debug] || $debug
      yield server
    end
  end

  # as USER, :with => ENVARLIST, :debug => [true|false], :norun => [true|false]

  def as user, opts = {}
    @user = user
    merge_opts_with_env opts
    yield if block_given?
  end

  # with ENVARLIST, :VAR1 => value, :debug => ...

  def with env, opts = {}
    merge_opts_with_env opts
    yield if block_given?
  end

  def ssh_command cmd
    ssh = "ssh -A"
    ssh += " -u #{@user}" unless @user.nil?
    ssh += " #{@server}"
    @envars.each do |env|
      # explicit values in the options list override the environment values
      val = @opts.key?(env) ? @opts[env] : ENV[env]
      if !(val.nil? || val.empty?)
        ssh += sprintf(" %s='%s'", env, val.gsub("'", "\'"))
      end
    end
    ssh += " " + cmd.to_s
    ssh
  end

  def _show_cmd cmd
    if @opts[:norun] || $norun
      talkf "(norun) %s\n", cmd
    elsif @opts[:debug] || $debug || @opts[:verbose] || $verbose
      talkf "--> %s\n", cmd
    end
  end

  # remote_run COMMAND
  # run the remote command

  def remote_run cmd
    ssh = ssh_command(cmd)
    _show_cmd ssh
    system(ssh) unless @opts[:norun] || $norun
  end
  alias :run_remotely :remote_run


  def remote_run_with_output cmd, opts = {}
    merge_opts_with_env opts
    ssh = ssh_command cmd
    _show_cmd ssh
    out = nil
    IO.popen(ssh) {|f| out = f.read }
    out
  end
  alias :capture :remote_run_with_output
  alias :rrout   :remote_run_with_output

end

include SSH_Utils

# end of ssh-utils.rb
# vim: sw=2:ai
