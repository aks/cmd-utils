#!/usr/bin/env ruby
# test-run-utils.rb -- simple tester for cmd-utils

$:.unshift '.', 'lib', '../lib'

require 'rubygems'
require 'helper'

require 'run-utils'

# these routines produce output on STDERR depending on $norun, $verbose, and $quiet.

class TestRunUtils < Minitest::Test

  include Run_Test

  def test_run_output
    run_test("run 1", 'n', false,     "(norun) echo 'hello'\n") { cmd_run "echo 'hello'" }
    run_test("run 2", 'v', "hello\n", ">> echo 'hello'\n")      { cmd_run "echo 'hello'" }
    run_test("run 3", '',  "hello\n", false)                    { cmd_run "echo 'hello'" }
    run_test("run 4", '',  false,     "hello\n")                { cmd_run "echo 'hello' 1>&2" }
    run_test("run 5", '',  false,     false)                    { cmd_run "echo"        }
  end

  def test_run_errmsg
    run_test("run 11", 'n', false,     "(norun) ( exit 1)\n")           { cmd_run "( exit 1)", 'error 11' }
    run_test("run 12", 'v', false,     />> \( exit 1\).*\nerror 12\n/m) { cmd_run "( exit 1)", 'error 12' }
    run_test("run 13", 'v', false,     ">> ( exit 0)\n")                { cmd_run "( exit 0)", 'no error 13' }
    run_test("run 14", ' ', false,     false)                           { cmd_run "( exit 0)", 'no error 13' }
  end
end
