# error-utils.rb -- simple utilities for managing errors to $stderr
#
# Copyright 2013-2015, Alan K. Stebbens <aks@stebbens.org>
#
#
#    require 'error-utils'
#
# Provides:
#
#    error   [code,]  msg
#    error(  [code]){ msg }
#    error  {[code,]  msg }
#
#    errorf  [code,]  fmt, *args
#    errorf( [code,] fmt) { *args }
#    errorf {[code,] fmt, *args }
#

require 'arg-utils'

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

# end of error-utils.sh
# vim: set ai sw=2
