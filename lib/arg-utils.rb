# arg-utils.rb -- simple methods for managing variable argument lists
#
# Alan K. Stebbens <aks@stebbens.org>
#
#
#    require 'arg-utils'
#
# defines two methods:
#
#   _msgargs(args, block_given?) { yield }
#   _fmtargs(args, block_given?) { yield }
#
# These two functions can be used to pass a variable list of arguments
# to a function accepting such, including possibly using a BLOCK to
# produce some (or all) of the values.
#
# Example:
#
#   def dtalkf(*args) {
#     if $debug
#       $stderr.printf(*_fmtargs(args, block_given?) { yield })
#     end
#   }
#
# The arguments pass to `printf` will come from either the arguments
# passed to `dtalkf` or the BLOCK given on the call to `dtalkf`.
#

####
# _msgargs(args, block_given?) { yield }
#
# merge args with any block results

def _msgargs args, flag
  args.concat([yield].flatten) if flag
  args
end

####
# _fmtargs(args, block_given?) { yield }
#
# merge args with any block results
# provide default format string if only one argument

def _fmtargs args, flag
  args.concat([yield].flatten) if flag
  args.unshift('%s') if args.size < 2
  args
end

# end of arg-utils.sh
# vim: set ai sw=2
