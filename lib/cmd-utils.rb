# cmd-utils.rb -- simple utilities for ruby command line tools
#
# Alan K. Stebbens <aks@stebbens.org>
#
#
#    require 'cmd-utils'
# 
# Utilities for output, running commands, and looking up values.
#
# The output and run methods rely on some external variables:
#
#    $verbose -- causes certain commands to talk more
#    $norun   -- causes the "run" command to print its argument, but not actually run it.
#    $quiet   -- causes certain commands to talk less
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
#    talk        msg
#    talk      { msg }
#    talkf fmt, args ...
#    talkf fmt { [ args ... ] }

def talk msg=nil
  if !$quiet && (msg || block_given?)
    $stderr.puts(msg || yield)
  end
end

def talkf fmt='%s', *args
  args = yield if args.size == 0 && block_given?
  talk { sprintf(fmt, *args) }
end

##
# qtalk - Print msg on STDERR only if `$quiet` is set
#
# :call-seq:
#     qtalk   msg
#     qtalk { msg }
#     qtalkf fmt,    args ..
#     qtalkf fmt { [ args .. ] }

def qtalk msg=nil
  if $quiet && (msg || block_given?)
    $stderr.puts(msg || yield)
  end
end

def qtalkf fmt='%s', *args 
  args = yield if args.size == 0 && block_given?
  qtalk { sprintf(fmt, *args) }
end

##
# vtalk -- Print msg on STDERR if `$verbose` is set
#
# :call-seq:
#     vtalk   msg
#     vtalk { msg }
#     vtalkf fmt, args ..
#     vtalkf fmt { args .. }

def vtalk msg=nil
  if $verbose && (msg || block_given?)
    $stderr.puts(msg || yield)
  end
end

def vtalkf fmt='%s', *args
  args = yield if args.size == 0 && block_given?
  vtalk { sprintf(fmt, *args) }
end

##
# nvtalk -- Print msg on STDERR unless `$verbose` is set
#
# :call-seq:
#     nvtalk msg
#     nvtalk { msg }

def  nvtalk msg=nil
  unless $verbose && (msg || block_given?)
    $stderr.puts(msg || yield)
  end
end

def nvtalkf fmt='%s', *args
  args = yield if args.size == 0 && block_given?
  nvtalk { sprintf(fmt, *args) }
end

##
# nrtalk -- Print msg on STDERR only if `$norun` is set
#
# :call-seq:
#     nrtalk        msg
#     nrtalk      { msg }
#     nrtalkf fmt,  msg
#     nrtalkf fmt { msg }

def nrtalk msg=nil
  if $norun
    $stderr.puts(msg || yield)
  end
end

def nrtalkf *args
  args = yield if args.size == 0 && block_given?
  nrtalk { sprintf(*args) }
end

##
# error -- print an error message on STDERR, and then exit.
# :call-seq:
#     error [code], msg
#     errof [code], fmt, args
#
# Code defaults to 1 if not given.

def error *args
  args = yield if args.size == 0 && block_given?
  code = args.size > 0 && args[0].class == Fixnum ? args.shift : 1
  $stderr.puts(*args)
  exit code
end

def errorf *args
  args = yield if args.size == 0 && block_given?
  code = args.size > 0 && args[0].class == Fixnum ? args.shift : 1
  $stderr.printf(*args)
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
# block.

def run cmd=nil
  cmd ||= block_given? && yield
  if $norun
    $stderr.printf "(norun) %s\n", cmd
  else
    safe_run cmd
  end
end

def safe_run cmd=nil
  cmd ||= block_given? && yield
  vtalkf { [ ">> %s\n", cmd ] }
  system cmd
  if $? > 0
    qtalkf { [ ">> %s\n", cmd ] }
    errorf $?, "Command failed with code %d!\n", $?
  end
end

## 
# :call-seq:
#     result = lookup list, key, err_notfound="%s not found", err_ambig="% is ambiguous"
#     result = list.lookup( key, err_notfound, err_ambig )
#     result = list.lookup( key, err_notfound )
#     result = list.lookup( key )
#
# Lookup key in list, which is an array (or hash).  Return the one that matches
# unambiguously, or report an error.
#
# If err_notfound is nil, do not report an error, and return nil.
#
# If err_ambigmsg is nil, return the list of possible results.

def key_lookup list, key, err_notfound="%s not found\n", err_ambig="%s is ambiguous\n"
  keylist = list.keys if list.class == Hash
  if exact = keylist.grep(/^#{key}$/i)         # exact matche?
    return exact 
  end
  keys = keylist.grep(/^#{key}/i)
  case keys.size
  when 0
    unless err_notfound.nil?
      errorf err_notfound, key
    end
    return nil
  when 1
    return keys[0]
  else
    unless err_ambig.nil?
      errorf err_ambig, key
    end
    return keys
  end
end

alias lookup key_lookup

class Array
  def lookup key, err_notfound="%s not found\n", err_ambig="%s is ambiguous\n"
    key_lookup self, key, err_notfound, err_ambig
  end
end
    

# end of cmd-utils.sh
# vim: set ai sw=2
