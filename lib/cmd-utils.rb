# cmd-utils.rb -- simple utilities for ruby command line tools
#
# Alan K. Stebbens <aks@stebbens.org>
#
#
#    require 'cmd-utils'
# 
# Utilities for option-controlled output, and running commands.
#
# The output and run methods rely on some external variables:
#
#    $verbose -- enables vtalk(f) output
#    $norun   -- enables nrtalk(f) output and controls the "run" command
#    $quiet   -- enables qtalk(f) output, and disables talk(f) output
#    $debug   -- enables dtalk(f) output
#
# These routines provide conditional output.  The arguments can be given as part of the
# the function calls, or, can be provided as the return value of a block.  The advantage
# of using a block is that the block is not evaluated unless the conditions requiring
# output are met.  So, if the expression to compute a value that _might_ be printed is
# expensive, do the computation inside a block.
#
##
# talk - Print msg on STDERR unless `$quiet` is set
#
# :call-seq:
#    talk        msg ..
#    talk      { msg .. }
#    talkf fmt, args ...
#    talkf fmt { [ args ... ] }

def talk *args
  if !$quiet && (args.size > 0 || block_given?)
    $stderr.puts(*_msgargs(args, block_given?) { yield })
  end
end

def talkf *args
  talk { sprintf(*_fmtargs(args, block_given?) { yield } ) }
end

# _msgargs(args, block_given?) { yield }
#
# merge args with any block results

def _msgargs args, flag
  args.concat([yield].flatten) if flag
  args
end

# _fmtargs(args, block_given?) { yield }
#
# merge args with any block results
# provide default format string if only one argument

def _fmtargs args, flag
  args.concat([yield].flatten) if flag
  args.unshift('%s') if args.size < 2
  args
end

##
# dtalk - "debug talk" 
# Print msg on STDERR only if `$debug` is set
#
# :call-seq:
#     dtalk   msg
#     dtalk { msg }
#     dtalkf fmt,    args ..
#     dtalkf fmt { [ args .. ] }

def dtalk *args
  if $debug && (args.size > 0 || block_given?)
    $stderr.puts(*_msgargs(args, block_given?) { yield })
  end
end

def dtalkf *args 
  dtalk { sprintf(*_fmtargs(args, block_given?) { yield } ) }
end

##
# qtalk - "quiet talk"
# print msg on STDERR only if `$quiet` is set
#
# :call-seq:
#     qtalk   msg
#     qtalk { msg }
#     qtalkf fmt,    args ..
#     qtalkf fmt { [ args .. ] }

def qtalk *args
  if $quiet && (args.size > 0 || block_given?)
    $stderr.puts(*_msgargs(args, block_given?) { yield })
  end
end

def qtalkf *args 
  qtalk { sprintf(*_fmtargs(args, block_given?) { yield } ) }
end

##
# vtalk - "verbose talk"
# Print msg on STDERR if `$verbose` is set
#
# :call-seq:
#     vtalk   msg
#     vtalk { msg }
#     vtalkf fmt, args ..
#     vtalkf fmt { args .. }

def vtalk *args
  if $verbose && (args.size > 0 || block_given?)
    $stderr.puts(*_msgargs(args, block_given?) { yield })
  end
end

def vtalkf *args
  vtalk { sprintf(*_fmtargs(args, block_given?) { yield } ) }
end

##
# nvtalk -- "non-verbose" talk
# Print msg on STDERR unless `$verbose` is set
#
# :call-seq:
#     nvtalk msg
#     nvtalk { msg }

def  nvtalk *args
  unless $verbose && (args.size > 0 || block_given?)
    $stderr.puts(*_msgargs(args, block_given?) { yield })
  end
end

def nvtalkf *args
  nvtalk { sprintf(*_fmtargs(args, block_given?) { yield } ) }
end

##
# nrtalk -- "no run" talk
# Print msg, prefixed with "(norun) ", on STDERR only if `$norun` is set
#
# :call-seq:
#     nrtalk        msg
#     nrtalk      { msg }
#     nrtalkf fmt,  msg
#     nrtalkf fmt { msg }

def nrtalk *args
  if $norun && (args.size > 0 || block_given?)
    newargs = _msgargs(args, block_given?) { yield }
    newargs[0] = '(norun) ' + newargs[0] unless newargs.size == 0 || newargs[0].nil? || newargs[0].include?('(norun)')
    $stderr.puts(*newargs)
  end
end

def nrtalkf *args
  nrtalk { sprintf(*_fmtargs(args, block_given?) { yield } ) }
end

##
# error -- print an error message on STDERR, and then exit.
# :call-seq:
#     error   [code],   msg
#     error(  [code]) { msg }
#     error {[[code],   msg ] }
#
# Code defaults to 1 if not given.

def error *args
  args = _msgargs(args, block_given?) { yield }
  code = args.size > 0 && args[0].class == Fixnum ? args.shift : 1
  $stderr.puts(*args)
  $stderr.flush
  exit code
end

##
# errorf -- print a formatted message on STDERR, and then exit
#
# :call-seq:
#     errorf   [code],   fmt,   args ..
#     errorf(  [code],   fmt) { args .. }
#     errorf(  [code]) { fmt,   args .. }
#     errorf {[[code],   fmt,   args .. ] }

def errorf *args
  args = _fmtargs(args, block_given?) { yield }
  # default the error code to 1 unless the first argument is a Fixnum
  code = args.size > 0 && args[0].class == Fixnum ? args.shift : 1
  $stderr.printf(*args)
  $stderr.flush
  exit code
end

##
# run -- run a command with support for testing, diagnostics and verbosity
# safe_run -- run a command with support for diagnostics and verbosity
#
# :call-seq:
#     run        cmd
#     run      { cmd }
#     safe_run   cmd
#     safe_run { cmd }
#
# if `$norun` is set, print `(norun) ` followed by `cmd` on `STDERR`, and
# return.
#
# if `$verbose` is set, print `>> ` followed by `cmd` on `STDERR`.
#
# Invoke the `cmd` with the `system()` call.
#
# If there is an error, show the command (preceded by `>> `) if `$verbose` is
# not set, then show the error code.
#
# The `cmd` can be given either as an argument, or as the returned value from a
# block.  Important: the block should return a string value to be passed to 
# the system call.

def run cmd=nil
  cmd ||= block_given? && yield
  if $norun
    nrtalk cmd
  else
    safe_run cmd
  end
end

def safe_run cmd=nil
  cmd ||= block_given? && yield
  vtalkf ">> %s\n", cmd
  system cmd
  if $? > 0
    qtalkf ">> %s\n", cmd
    errorf $?, "Command failed with code %d!\n", $?
  end
end

# end of cmd-utils.sh
# vim: set ai sw=2
