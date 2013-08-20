#!/usr/bin/env ruby
# test-cmd-utils.rb -- simple tester for cmd-utils
#
require 'rubygems'
require 'minitest'
require 'minitest/autorun'
require 'cmd-utils'

# these routines produce output on STDERR depending on $norun, $verbose, and $quiet.

class TestCmdUtils < MiniTest::Test

  def gen_test name, norun, verbose, quiet, output
    $norun   = norun > 0
    $verbose = verbose > 0
    $quiet   = quiet > 0
    out, err = capture_io { yield }
    assert_empty(out, "#{name} $stdout should be empty")
    case output
    when TrueClass
      refute_empty(err, "#{name} $stderr should not be empty")
    when FalseClass
      assert_empty(err, "#{name} $stderr should be empty")
    when String
      assert_match(out, output, "#{name} $stderr should match #{output}")
    end
    true
  end


  def test_talk_arg
    #           nr, verb, quiet, output?
    gen_test('talk_arg', 0, 0, 0, true)    { talk "hello" }
    gen_test('talk_arg', 0, 0, 1, false)   { talk "hello" }
    gen_test('talk_arg', 0, 1, 0, true)    { talk "hello" }
    gen_test('talk_arg', 0, 1, 1, false)   { talk "hello" }
    gen_test('talk_arg', 1, 0, 0, true)    { talk "hello" }
    gen_test('talk_arg', 1, 0, 1, false)   { talk "hello" }
    gen_test('talk_arg', 1, 1, 0, true)    { talk "hello" }
    gen_test('talk_arg', 1, 1, 1, false)   { talk "hello" }
  end

  def test_talk_content
    gen_test('talk_content', 0, 0, 0, "hello") { talk "hello" }
    gen_test('talk_content_block', 0, 0, 0, "hello") { talk { "hello" } }
  end

  def test_talk_block
    #           nr, verb, quiet, output?
    gen_test('talk', 0, 0, 0, true)    { talk { "hello" } }
    gen_test('talk', 0, 0, 1, false)   { talk { "hello" } }
    gen_test('talk', 0, 1, 0, true)    { talk { "hello" } }
    gen_test('talk', 0, 1, 1, false)   { talk { "hello" } }
    gen_test('talk', 1, 0, 0, true)    { talk { "hello" } }
    gen_test('talk', 1, 0, 1, false)   { talk { "hello" } }
    gen_test('talk', 1, 1, 0, true)    { talk { "hello" } }
    gen_test('talk', 1, 1, 1, false)   { talk { "hello" } }
  end

  def test_talkf_arg
    #           nr, verb, quiet, output?
    gen_test('talkf_arg', 0, 0, 0, true)    { talkf "%s", "hello" }
    gen_test('talkf_arg', 0, 0, 1, false)   { talkf "%s", "hello" }
    gen_test('talkf_arg', 0, 1, 0, true)    { talkf "%s", "hello" }
    gen_test('talkf_arg', 0, 1, 1, false)   { talkf "%s", "hello" }
    gen_test('talkf_arg', 1, 0, 0, true)    { talkf "%s", "hello" }
    gen_test('talkf_arg', 1, 0, 1, false)   { talkf "%s", "hello" }
    gen_test('talkf_arg', 1, 1, 0, true)    { talkf "%s", "hello" }
    gen_test('talkf_arg', 1, 1, 1, false)   { talkf "%s", "hello" }
  end

  def test_talkf_block
    #           nr, verb, quiet, output?
    gen_test('talkf_block', 0, 0, 0, true)    { talkf("%s") { "hello" } }
    gen_test('talkf_block', 0, 0, 1, false)   { talkf("%s") { "hello" } }
    gen_test('talkf_block', 0, 1, 0, true)    { talkf("%s") { "hello" } }
    gen_test('talkf_block', 0, 1, 1, false)   { talkf("%s") { "hello" } }
    gen_test('talkf_block', 1, 0, 0, true)    { talkf("%s") { "hello" } }
    gen_test('talkf_block', 1, 0, 1, false)   { talkf("%s") { "hello" } }
    gen_test('talkf_block', 1, 1, 0, true)    { talkf("%s") { "hello" } }
    gen_test('talkf_block', 1, 1, 1, false)   { talkf("%s") { "hello" } }
  end

  def test_talkf_content
    gen_test('talkf_content', 0, 0, 0, "-hello-")       { talkf "-%s-",   "hello" }
    gen_test('talkf_content', 0, 0, 0, "-hello-")       { talkf("-%s-") { "hello" } }
    gen_test('talkf_default_content', 0, 0, 0, 'hello') { talkf           "hello" }
    gen_test('talkf_default_content', 0, 0, 0, 'hello') { talkf         { "hello" } }
  end

  def test_qtalk_arg
    #                nr,vrb,q, out?
    gen_test('qtalk', 0, 0, 0, false)   { qtalk "hello" }
    gen_test('qtalk', 0, 0, 1, true)    { qtalk "hello" }
    gen_test('qtalk', 0, 1, 0, false)   { qtalk "hello" }
    gen_test('qtalk', 0, 1, 1, true)    { qtalk "hello" }
    gen_test('qtalk', 1, 0, 0, false)   { qtalk "hello" }
    gen_test('qtalk', 1, 0, 1, true)    { qtalk "hello" }
    gen_test('qtalk', 1, 1, 0, false)   { qtalk "hello" }
    gen_test('qtalk', 1, 1, 1, true)    { qtalk "hello" }
  end

  def test_qtalk_block
    #           nr, verb, quiet, output?
    gen_test('qtalk', 0, 0, 0, false)   { qtalk { "hello" } }
    gen_test('qtalk', 0, 0, 1, true)    { qtalk { "hello" } }
    gen_test('qtalk', 0, 1, 0, false)   { qtalk { "hello" } }
    gen_test('qtalk', 0, 1, 1, true)    { qtalk { "hello" } }
    gen_test('qtalk', 1, 0, 0, false)   { qtalk { "hello" } }
    gen_test('qtalk', 1, 0, 1, true)    { qtalk { "hello" } }
    gen_test('qtalk', 1, 1, 0, false)   { qtalk { "hello" } }
    gen_test('qtalk', 1, 1, 1, true)    { qtalk { "hello" } }
  end

  def test_qtalk_content
    gen_test('qtalk_content', 0, 0, 1, "-hello-") { qtalk "hello" }
    gen_test('qtalk_content', 0, 0, 1, "-hello-") { qtalk { "hello" } }
  end

  def test_qtalkf_content
    gen_test('qtalkf_content', 0, 0, 1, "-hello-")         { qtalkf "-%s-",   "hello" }
    gen_test('qtalkf_content', 0, 0, 1, "-hello-")         { qtalkf("-%s-") { "hello" } }
    gen_test('qtalkf_default_content', 0, 0, 1, "-hello-") { qtalkf           "hello" }
    gen_test('qtalkf_default_content', 0, 0, 1, "-hello-") { qtalkf         { "hello" } }
  end

  def test_vtalk_arg
    #           nr, verb, quiet, output?
    gen_test('vtalk_arg', 0, 0, 0, false)   { vtalk "hello" }
    gen_test('vtalk_arg', 0, 0, 1, false)   { vtalk "hello" }
    gen_test('vtalk_arg', 0, 1, 0, true)    { vtalk "hello" }
    gen_test('vtalk_arg', 0, 1, 1, true)    { vtalk "hello" }
    gen_test('vtalk_arg', 1, 0, 0, false)   { vtalk "hello" }
    gen_test('vtalk_arg', 1, 0, 1, false)   { vtalk "hello" }
    gen_test('vtalk_arg', 1, 1, 0, true)    { vtalk "hello" }
    gen_test('vtalk_arg', 1, 1, 1, true)    { vtalk "hello" }
  end

  def test_vtalk_block
    #           nr, verb, quiet, output?
    gen_test('vtalk_block', 0, 0, 0, false)   { vtalk { "hello" } }
    gen_test('vtalk_block', 0, 0, 1, false)   { vtalk { "hello" } }
    gen_test('vtalk_block', 0, 1, 0, true)    { vtalk { "hello" } }
    gen_test('vtalk_block', 0, 1, 1, true)    { vtalk { "hello" } }
    gen_test('vtalk_block', 1, 0, 0, false)   { vtalk { "hello" } }
    gen_test('vtalk_block', 1, 0, 1, false)   { vtalk { "hello" } }
    gen_test('vtalk_block', 1, 1, 0, true)    { vtalk { "hello" } }
    gen_test('vtalk_block', 1, 1, 1, true)    { vtalk { "hello" } }
  end

  def test_nvtalk_arg
    #           nr, verb, quiet, output?
    gen_test('nvtalk_arg', 0, 0, 0, true)     { nvtalk "hello" }
    gen_test('nvtalk_arg', 0, 0, 1, true)     { nvtalk "hello" }
    gen_test('nvtalk_arg', 0, 1, 0, false)    { nvtalk "hello" }
    gen_test('nvtalk_arg', 0, 1, 1, false)    { nvtalk "hello" }
    gen_test('nvtalk_arg', 1, 0, 0, true)     { nvtalk "hello" }
    gen_test('nvtalk_arg', 1, 0, 1, true)     { nvtalk "hello" }
    gen_test('nvtalk_arg', 1, 1, 0, false)    { nvtalk "hello" }
    gen_test('nvtalk_arg', 1, 1, 1, false)    { nvtalk "hello" }
  end

  def test_nvtalk_block
    #           nr, verb, quiet, output?
    gen_test('nvtalk_block', 0, 0, 0, true)     { nvtalk { "hello" } }
    gen_test('nvtalk_block', 0, 0, 1, true)     { nvtalk { "hello" } }
    gen_test('nvtalk_block', 0, 1, 0, false)    { nvtalk { "hello" } }
    gen_test('nvtalk_block', 0, 1, 1, false)    { nvtalk { "hello" } }
    gen_test('nvtalk_block', 1, 0, 0, true)     { nvtalk { "hello" } }
    gen_test('nvtalk_block', 1, 0, 1, true)     { nvtalk { "hello" } }
    gen_test('nvtalk_block', 1, 1, 0, false)    { nvtalk { "hello" } }
    gen_test('nvtalk_block', 1, 1, 1, false)    { nvtalk { "hello" } }
  end

  def test_nrtalk_arg
    #           nr, verb, quiet, output?
    gen_test('nrtalk_arg', 0, 0, 0, false)     { nrtalk "hello" }
    gen_test('nrtalk_arg', 0, 0, 1, false)     { nrtalk "hello" }
    gen_test('nrtalk_arg', 0, 1, 0, false)     { nrtalk "hello" }
    gen_test('nrtalk_arg', 0, 1, 1, false)     { nrtalk "hello" }
    gen_test('nrtalk_arg', 1, 0, 0, true)      { nrtalk "hello" }
    gen_test('nrtalk_arg', 1, 0, 1, true)      { nrtalk "hello" }
    gen_test('nrtalk_arg', 1, 1, 0, true)      { nrtalk "hello" }
    gen_test('nrtalk_arg', 1, 1, 1, true)      { nrtalk "hello" }
  end

  def test_nrtalk_block
    #           nr, verb, quiet, output?
    gen_test('nrtalk_block', 0, 0, 0, false)    { nrtalk { "hello" } }
    gen_test('nrtalk_block', 0, 0, 1, false)    { nrtalk { "hello" } }
    gen_test('nrtalk_block', 0, 1, 0, false)    { nrtalk { "hello" } }
    gen_test('nrtalk_block', 0, 1, 1, false)    { nrtalk { "hello" } }
    gen_test('nrtalk_block', 1, 0, 0, true)     { nrtalk { "hello" } }
    gen_test('nrtalk_block', 1, 0, 1, true)     { nrtalk { "hello" } }
    gen_test('nrtalk_block', 1, 1, 0, true)     { nrtalk { "hello" } }
    gen_test('nrtalk_block', 1, 1, 1, true)     { nrtalk { "hello" } }
  end

  def test_nrtalkf_content
    gen_test('nrtalkf_content', 0, 0, 1, "-hello-")         { nrtalkf "-%s-",   "hello" }
    gen_test('nrtalkf_content', 0, 0, 1, "-hello-")         { nrtalkf("-%s-") { "hello" } }
    gen_test('nrtalkf_default_content', 0, 0, 1, "-hello-") { nrtalkf           "hello" }
    gen_test('nrtalkf_default_content', 0, 0, 1, "-hello-") { nrtalkf         { "hello" } }
  end

end
