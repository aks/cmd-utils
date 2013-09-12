cmd-utils
=========

Utilities for writing command line tools in ruby.

Installation:

    gem install cmd-utils

Usage:

    require 'cmd-utils'
    require 'lookup'

This gem provides:

* routines for output on `$stderr`, controlled by several global variables
* error-reporting-and-exit
* system call handling, with verbose or debug output, error and "ok" message handling
* ambiguous, case-insensitive string lookups in arrays or hashs, with error handling

talk, dtalk, qtalk, vtalk, nrtalk, nvtalk
=========================================

These utilities provide simple utilities that rely on the following global variables:

    `$verbose` -- enables vtalk(f) function output
    `$norun`   -- enables nrtalk(f) output, and disables the "run" command execution
    `$quiet`   -- disables talk(f) output, and enables qtalk(f) function output
    `$debug`   -- enables dtalk(f) function output

These routines provide option-controlled output.  The arguments can be given as
part of the the function calls, or, can be provided as the return value of a
block.

The advantage of using a block is that the block is not evaluated unless the
conditions requiring output are met.  So, if the expression to compute a value
that _might_ be printed is expensive, do the computation inside a block.

The brief synopses given below show the function calls with arguments, and then
the function calls with the arguments passed as the block's return value.

Talk:

      talk    msg         - print msg on STDERR unless $quiet
      talk  { msg }
      talkf fmt,   args ..
      talkf(fmt) { args .. }

Debug talk:

     dtalk    msg         - print msg on STDERR if $debug
     dtalk  { msg }
     dtalkf fmt,   args ..
     dtalkf(fmt) { args .. }

Quiet talk:

     qtalk   msg         - print msg on STDERR if     $quiet
     qtalk { msg }
     qtalkf fmt,   args ..
     qtalkf(fmt) { args .. }

Verbose talk:

     vtalk   msg         - print msg on STDERR if     $verbose
     vtalk { msg }
     vtalkf fmt,   args ..
     vtalkf(fmt) { args .. }

No-run talk:

    nrtalk   msg         - print msg on STDERR if     $norun || $verbose
    nrtalk { msg }
    nrtalkf fmt,   args ..
    nrtalkf(fmt) { args .. }

Non-verbose talk:

    nvtalk   msg         - print msg on STDERR unless $verbose
    nvtalk { msg }
    nvtalkf fmt,   args ..
    nvtalkf(fmt) { args .. }

Error output:

    error      [code,] msg   - print msg on STDERR, exit with CODE [default:1]
    error  { [ [code,] msg ] }
    errorf     [code,] fmt, args ..
    errorf { [ [code,] fmt, args .. ] }

The `error` routine take an optional numeric first argument which is used to
set the exit code.  If not given, the exit code is 1.

`cmd_run` ========

    cmd_run     cmd 
    cmd_run   { cmd }

Variants:

    cmd_run     cmd,     errmsg 
    cmd_run     cmd,     errmsg, okmsg 
    cmd_run    (cmd) { [ errmsg, okmsg ] } 
    cmd_run { [ cmd,     errmsg, okmsg ] }

The `cmd_run` method depends on the `$norun` and `$verbose` global variables.
If `$norun` is set, the `cmd` is simply displayed with a prefix of `(norun) `,
and the method returns without invoking `cmd`.

When `$norun` is false, and if `$verbose` is set, the `cmd` is displayed with
a prefix of `">> "` before executing it.

If result of invoking `system(cmd)` is an error (non-zero exit code), then an
error is printed on `$stderr`, possibly preceded by the command itself if it
was not already printed.

Note that when using the block forms of run (e.g., `run { cmd }`), the result
of the block should be an array of one or more strings, in the same order as
the arguments. The block will always be evaluated in order to obtain the string
values that will be printed in `$norun` mode, or used as the error or ok
messages.

The `safe_run` method invokes `cmd`, regardless of `$norun`, basically wrapping the 
command evaluation with the `$verbose` treatment.

    safe_run   cmd
    safe_run   cmd,   errmsg
    safe_run   cmd,   errmsg,  okmsg
    safe_run  (cmd) {[errmsg,  okmsg]}
    safe_run { cmd } 
    safe_run {[cmd, errmsg, okmsg]} 

lookup
======

usage:

     require 'lookup'
  
lookup: lookup a keyword in a list, in a case-insensitive, disambiguous way
 
      result = lookup list, key, err_notfound="%s not found", err_ambig="% is ambiguous"
      result = list.lookup( key, err_notfound, err_ambig )
      result = list.lookup( key, err_notfound )
      result = list.lookup( key )
 
Lookup key in list, which can be an array or a hash.  Return the one that
matches exactly, or matches using case-insensitive, unambiguous matches, or
raise a LookupError with a message.
 
`LookupError` is a subclass of StandardError.
 
`LookupNotFoundError`, a subclass of `LookupError`, is raised when a keyword is
not found, and only if `err_notfound` is not nil.
 
`LookupAmbigError`, a subsclass of `LookupError`, is raised when a keyword search
matches multiple entries from the list, and only if `err_ambig` is not nil.
 
If `err_notfound` is nil, do not raise a `LookupNotFoundError` error, and return
nil.
 
If `err_ambigmsg` is nil, do not raise a `LookupAmbigError`, and return the list
of possible results.

Author
------

Alan K. Stebbens <aks@stebbens.org>
