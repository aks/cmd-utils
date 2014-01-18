# ssh-utils.rb
#
# A module to define some routines for running commands across many systems
# using ssh
#
# Copyright 2013, Alan K. Stebbens <aks@stebbens.org>
#
# Usage:
#
#    require 'ssh-utils'
#
#    on serverlist, :debug = true do |server|
#      as user do
#        remote_run :whoami
#      end
#    end

require 'rubygems'
require 'cmd-utils'

module SSH_Utils

  attr_reader   :server
  attr_accessor :servers

  @opts = {}
  @opts.default = nil

  def merge_opts opts = {}
    @opts ||= {}
    @opts.merge!(opts) unless opts.empty?
  end


  def on servers, opts = {}
    merge_opts opts
    (@servers = servers).each do |server|
      @server = server
      talk("--> Running block for server #{server}..") if @opts[:debug]
      yield server
    end
  end


  def as user, opts = {}
    @user = user
    merge_opts opts
    yield if block_given?
  end


  def _ssh_command cmd
    ssh = "ssh -A"
    ssh += " -u #{@user}" unless @user.nil?
    ssh += " #{@server}"
    ssh += " " + cmd.to_s
    ssh
  end


  def remote_run cmd
    ssh = _ssh_command(cmd)
    talk("--> " + ssh) if @opts[:debug]
    system ssh
  end
  alias :run_remotely :remote_run


  def remote_run_with_output cmd, opts = {}
    merge_opts opts
    ssh = _ssh_command cmd
    talk("--> " + ssh) if @opts[:debug]
    out = nil
    IO.popen(ssh) {|f| out = f.readlines }
    out
  end
  alias :capture :remote_run_with_output
  alias :rrout   :remote_run_with_output

end

include SSH_Utils

# vim: sw=2:ai
