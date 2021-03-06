# cmd-utils

Utilities for writing command line tools in ruby.

Installation:

    gem install cmd-utils

Usage:

    require 'cmd-utils'   # include all libraries in this repo

or

    require 'arg-utils'
    require 'error-utils'
    require 'lookup'
    require 'run-utils'
    require 'ssh-utils'
    require 'talk-utils'

This gem provides:

* `arg-utils`: help manage variable argumentlists.
* `talk-utils`: routines for output on `$stderr`, controlled by several global variables.
* `error-utils`: error-reporting-and-exit.
* `run-utils`: system call handling, with verbose or debug output, error and "ok" message handling.
* `ssh-utils`: remote system command invocation (based on ssh).
* `lookup`: ambiguous, case-insensitive string lookups in arrays or hashs, with error handling.
* `cmd-utils`: includes all the above libraries.

## talk-utils: talk, dtalk, qtalk, vtalk, nrtalk, nvtalk

These utilities provide simple utilities that rely on the following global variables:

    $verbose -- enables vtalk(f) function output
    $norun   -- enables nrtalk(f) output, and disables the run command execution
    $quiet   -- disables talk(f) output, and enables qtalk(f) function output
    $debug   -- enables dtalk(f) function output

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
      talkf(fmt) {[args,..]}

Debug talk:

     dtalk    msg         - print msg on STDERR if $debug
     dtalk  { msg }
     dtalkf fmt,   args ..
     dtalkf(fmt) {[args,..]}

Quiet talk:

     qtalk   msg         - print msg on STDERR if     $quiet
     qtalk { msg }
     qtalkf fmt,   args ..
     qtalkf(fmt) {[args,..]}

Verbose talk:

     vtalk   msg         - print msg on STDERR if     $verbose
     vtalk { msg }
     vtalkf fmt,   args ..
     vtalkf(fmt) {[args,..]}

No-run talk:

    nrtalk   msg         - print msg on STDERR if     $norun || $verbose
    nrtalk { msg }
    nrtalkf fmt,   args ..
    nrtalkf(fmt) {[args, ..]}

Non-verbose talk:

    nvtalk   msg         - print msg on STDERR unless $verbose
    nvtalk { msg }
    nvtalkf fmt,   args ..
    nvtalkf(fmt) {[args ..]}

No-run or verbose talk:

    nrvtalk   msg         - print msg on STDERR prefixed with '(norun) ' or '>> '
    nrvtalk { msg }
    nrvtalkf fmt,    args ..
    nrvtalkf(fmt) {[args, ..]}
    nrvtalkf {[ fmt, args, ...]}

Error output:

    error    [code,] msg   - print msg on STDERR, exit with CODE [default:1]
    error  {[[code,] msg]}
    errorf   [code,] fmt, args ..
    errorf {[[code,] fmt, args ..]}

The `error` routine take an optional numeric first argument which is used to
set the exit code.  If not given, the exit code is 1.

## error-utils: `error`, `errorf`

The `error` and `errorf` family of methods make it easy display an error message
and then exit, possibly with a specific error code.

The arguments may be given as a parameters on the method, or as return values 
from a yield block.

    error   MSG
    error  {MSG}
    error  CODE,   MSG
    error( CODE) { MSG }
    error{ CODE,   MSG }

    errorf  FMT, *ARGS
    errorf( FMT){ ARGS }
    errorf{ FMT,  ARGS  }


## run-utils: `cmd_run`, `safe_run`

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

If the result of invoking `system(cmd)` is an error (non-zero exit code), then
an error is printed on `$stderr`, possibly preceded by the command itself if it
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

## ssh-utils

A module to define some routines for running commands across many systems using
ssh.  Environment variables can be specified (`PATH` is used by default).

Usage:

    require 'ssh-utils'

    on serverlist, :debug = true do |server|
      as user do
        with PATH do
          remote_run :whoami
        end
      end
    end

### `on`

    on SERVERLIST, OPTIONSHASH |server|
      BLOCK-TO-EXECUTE-FOR-EACH-SERVER
    end

The `on` method specifies a list of servers, with an optional hash of
options.  The supported options are: `:debug`, `:verbose`, `:with`, 
`:without`, and `:as`

    :with => ENVARS

`ENVARS` is an array of environment symbol names (or strings) that will
be included on the `ssh` command that is used to run remote commands.

    :without => ENVARS

`ENVARS` is an array of environment symbol names (or strings) that will *not*
be included on the `ssh` command that is used to run remote commands.  This
option is useful when overriding the default inclusion of `PATH`.  For example:

    on backupserver, :without => :PATH
      remote_run "/bin/tar", "-cf", source_path, dest_path
    end

    :as => USER

Specifies the user to be used for the subsequent invocations.  By default, 
the current user is used implicitly.

    :debug => [true | false]

Sets the `:debug` flag for use within the associated block.  The `$debug` flag
is globally available, but the `:debug` option is a block-local specification.

    :verbose => [true | false]

Sets the `:verbose` flag for use within the associated block.  The `$verbose` flag
is globally available, but the `:verbose` option is a block-local specification.

### `as`

    as USERLIST, OPTIONSHASH
      BLOCK-TO-EXECUTE-FOR-EACH-USER
    end

The `as` method is optional, and if absent causes the current user to
be used by default (unless overridden by the `~/.ssh/config` file).

The `as` method allows the embedded block to be repeated for each given user.
If there only one user, it can be specified on the `on` method with an `:as`
option.  For example, the following two sections are equivalent:

    on someserver
      as root
        remote_run :whoami
      end
    end

    on someserver, :as => 'root'
      remote_run :whoami
    end

### `with`

    as USERLIST, OPTIONSHASH do
      with SOMEENVAR do
        BLOCK-TO-EXECUTE-WITH-SOMEENVAR
      end
    end

The `with` method is used to set additional environment variables, or to
reset them.

## lookup-utils:

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

# Author

Alan K. Stebbens <aks@stebbens.org>
