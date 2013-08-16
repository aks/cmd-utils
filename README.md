cmd-utils
=========

Utilities for writing command line tools in ruby.

Installation:

    gem install cmd-utils

Usage:

    require 'cmd-utils'

These utilities provide simple utilities that rely on some global variables:

    `$verbose` -- causes certain commands to talk more
    `$norun`   -- causes the "run" command to print its argument, but not actually run it.
    `$quiet`   -- causes certain commands to talk less

These routines provide conditional output.  The arguments can be given as part
of the the function calls, or, can be provided as the return value of a block.

The advantage of using a block is that the block is not evaluated unless the
conditions requiring output are met.  So, if the expression to compute a value
that _might_ be printed is expensive, do the computation inside a block.

The brief synopses given below show the function calls with arguments, and then
the function calls with the arguments passed as the block's return value.

    talk  msg           - print msg on STDERR unless $quiet
    qtalk  msg          - print msg on STDERR if     $quiet
    vtalk  msg          - print msg on STDERR if     $verbose
    nrtalk  msg         - print msg on STDERR if     $norun || $verbose
    nvtalk  msg         - print msg on STDERR unless $verbose
    error [code,] msg   - print msg on STDERR, exit with CODE [default:1]

These are the same function calls with block arguments.

    talk { msg }
    qtalk { msg }
    vtalk { msg }
    nrtalk { msg }
    error { code ? [code, msg] : msg }

Sprintf-based variants:

    talkf fmt, args ..          - printf fmt, args on STDERR unless $quiet
    qtalkf fmt, args ..         - printf fmt, args on STDERR if     $quiet
    vtalkf fmt, args ..         - printf fmt, args on STDERR if     $verbose
    nrtalkf fmt, args ..        - printf fmt, args on STDERR if     $norun || $verbose
    nvtalkf fmt, args ..        - printf fmt, args on STDERR unless $verbose
    errorf [code], fmt, args .. - printf msg, args on STDERR; exit with CODE [1]

These are the function calls with block arguments.

    talkf { [ fmt, args, ... ] }      - printf fmt, args on STDERR unless $quiet
    qtalkf { [ fmt, args, ... ] }     - printf fmt, args on STDERR if     $quiet
    vtalkf { [ fmt, args, ... ] }     - printf fmt, args on STDERR if     $verbose
    nrtalkf { [ fmt, args, ... ] }    - printf fmt, args on STDERR if     $norun || $verbose
    nvtalkf { [ fmt, args, ... ] }    - printf fmt, args on STDERR unless $verbose
    errorf { [ [code,] fmt, args, ... ] } - printf fmt, args on STDERR; exit code[1]

The `run` method depends on the `$norun` and `$verbose` global variables.  if
`$norun` is set, the `cmd` is simply displayed with a prefix of `(norun) `, and
the method returns without invoking `cmd`.

When `$norun` is false, then, if `$verbose` is set, the `cmd` is displayed with
a prefix of `">> "` before executing it.

Finally, the `system` method is invoked on `cmd`.  If the exit code of the invoked
`cmd` is non-zero, an error message is printed.

    run        cmd
    run      { cmd }

The `safe_run` method invokes `cmd`, regardless of `$norun`, basically wrapping the 
command evaluation with the `$verbose` treatment.

    safe_run   cmd
    safe_run { cmd } 

The `lookup` routine makes it easy to lookup keywords and parameters (from the
command line, for example).

    result = lookup list, key, err_notfound="%s not found", err_ambig="% is ambiguous"

Lookup `key` in `list`, which is an array (or hash).  Return the one that matches
unambiguously, or report an error.

If `err_notfound` is nil, do not report an error, and return nil.

If `err_ambig` is nil, return the list of possible results.

Author
------

Alan K. Stebbens <aks@stebbens.org>
