# talk-utils.rb -- simple utilties for "talking" to $stderr
#
# Copyright 2013-2017, Alan K. Stebbens <aks@stebbens.org>
#
#    require 'talk-utils'
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
# These routines provide conditional output.  The arguments can be given as
# part of the the function calls, or, can be provided as the return value of a
# block.  The advantage of using a block is that the block is not evaluated
# unless the conditions requiring output are met.  So, if the expression to
# compute a value that _might_ be printed is expensive, do the computation
# inside a block.
#

require 'arg-utils'

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
  if !$quiet && (args.size > 0 || block_given?)
    $stderr.printf(*_fmtargs(args, block_given?) { yield } )
  end
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
#     dtalkf { [ fmt, args ..  ] }

def dtalk *args
  if $debug && (args.size > 0 || block_given?)
    $stderr.puts(*_msgargs(args, block_given?) { yield })
  end
end

def dtalkf *args
  if $debug && (args.size> 0 || block_given?)
    $stderr.printf(*_fmtargs(args, block_given?) { yield })
  end
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
#     qtalkf { [ fmt, args, ... ] }

def qtalk *args
  if $quiet && (args.size > 0 || block_given?)
    $stderr.puts(*_msgargs(args, block_given?) { yield })
  end
end

def qtalkf *args
  if $quiet && (args.size > 0 || block_given?)
    $stderr.printf(*_fmtargs(args, block_given?) { yield } )
  end
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
#     vtalkf { [ fmt, args ... ] }

def vtalk *args
  if $verbose && (args.size > 0 || block_given?)
    $stderr.puts(*_msgargs(args, block_given?) { yield })
  end
end

def vtalkf *args
  if $verbose && (args.size > 0 || block_given?)
    $stderr.printf(*_fmtargs(args, block_given?) { yield } )
  end
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
  unless $verbose && (args.size > 0 || block_given?)
    $stderr.printf(*_fmtargs(args, block_given?) { yield } )
  end
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
#     nrtalkf { [ fmt, msg ] }

def nrtalk *args
  if $norun && (args.size > 0 || block_given?)
    $stderr.puts(*_prefix_arg0(_msgargs(args, block_given?){yield},'(norun) '))
  end
end

def nrtalkf *args
  if $norun && (args.size > 0 || block_given?)
    $stderr.printf(*_prefix_arg0(_fmtargs(args, block_given?){yield},'(norun) '))
  end
end

# nrvtalk -- "no run" or verbose talk
#
# Print msg, possibly prefixed with "(norun)" or ">>" (verbose), on STDERR only
# if $norun or $verbose are set.
#
# :call-seq:
#     nrvtalk          msg
#     nrvtalk        { msg }
#     nrvtalkf   fmt,    args, ..
#     nrvtalkf   fmt { [ args, ..] }
#     nrvtalkf { [ fmt,  args .. ] }

def nrvtalk *args
  _args = _msgargs(args, block_given?) { yield }
  if $norun && _args.size > 0
    nrtalk(*_args)
  elsif $verbose && _args.size > 0
    vtalk(*_prefix_arg0(_args, '>> '))
  end
end

def nrvtalkf *args
  _args = _fmtargs(args, block_given?) { yield }
  if $norun && _args.size > 0
    nrtalkf(*_args)
  elsif $verbose && _args.size > 0
    vtalkf(*_prefix_arg0(_args, '>> '))
  end
end

# _prefix_arg0( args, prefix )
#
# Prefix args[0] if the prefix is not already there, and if the args[0] value is
# not nill.

def _prefix_arg0(args, prefix)
  if args.size > 0 && !args[0].nil? && !args[0].include?(prefix)
    args[0] = prefix + args[0]
  end
  args
end

# end of talk-utils.sh
# vim: set ai sw=2
