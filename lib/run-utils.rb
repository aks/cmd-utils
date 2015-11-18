# run-utils.rb -- simple utilities for running commands
#
# Copyright 2013-2015, Alan K. Stebbens <aks@stebbens.org>
#
#
#    require 'run-utils'
#
# Utilities for running commands.

require 'arg-utils'
require 'talk-utils'

# run -- run a command with support for testing, diagnostics and verbosity
# safe_run -- run a command with support for diagnostics and verbosity
#
# Both may be given optional `errmsg` and `okmsg`, which are printed if given
# for the corresponding condition.
#
# :call-seq:
#     run         cmd
#     run      {  cmd }
#     run         cmd, errmsg
#     run      { [cmd, errmsg] }
#     run      { [cmd, errmsg, okmg] }
#     run         cmd, errmsg, okmsg
#
#     safe_run    cmd
#     safe_run    cmd, errmsg
#     safe_run    cmd, errmsg, okmsg
#     safe_run {  cmd }
#     safe_run { [cmd, errmsg] }
#     safe_run { [cmd, errmsg, okmsg] }
#
# if `$norun` is set, print `(norun) ` followed by `cmd` on `STDERR`, and
# return.
#
# if `$verbose` is set, print `>> ` followed by `cmd` on `STDERR`.
#
# Invoke the `cmd` with the `system()` call.
#
# If there is an error, show the command (preceded by `>> `) if `$verbose` is
# not set, then show the error code, followed by the given `errmsg` or the
# default error message.
#
# The `cmd` can be given either as an argument, or as the returned value from a
# block.  Important: the block should return a string value to be passed to
# the system call.

def safe_run *args
  args = _msgargs(args, block_given?) { yield }
  cmd, errmsg, okmsg = args
  vtalkf ">> %s\n", cmd
  if cmd
    if system cmd              # invoke the command
      talk okmsg if okmsg
      return true
    else                        # an error occured
      qtalkf ">> %s\n", cmd
      erm = sprintf(errmsg ? errmsg : "Command failed with code %d", $?>>8)
      talk erm
      $stderr.flush
      raise SystemCallError, erm            # instead of exit, use raise
    end
  end
end

def cmd_run *args
  args = _msgargs(args, block_given?) { yield }
  if $norun
    nrvtalk(args.first)
  elsif args.size > 0
    safe_run(*args)
  end
end

alias run cmd_run

# end of run-utils.sh
# vim: set ai sw=2
