#!/usr/bin/env ruby
# test-talk-utils.rb -- simple tester for cmd-utils
#
$:.unshift '.', 'lib', '../lib'
require 'rubygems'
require 'helper'

require 'talk-utils'

# these routines produce output on STDERR depending on $norun, $verbose, and $quiet.

class TestTalkUtils < Minitest::Test

  include Gen_Test

  def test_talk_arg
    gen_test('talk_arg', '    ', true)    { talk "hello" }
    gen_test('talk_arg', '  q ', false)   { talk "hello" }
    gen_test('talk_arg', ' v  ', true)    { talk "hello" }
    gen_test('talk_arg', ' vq ', false)   { talk "hello" }
    gen_test('talk_arg', 'n   ', true)    { talk "hello" }
    gen_test('talk_arg', 'n q ', false)   { talk "hello" }
    gen_test('talk_arg', 'nv  ', true)    { talk "hello" }
    gen_test('talk_arg', 'nvq ', false)   { talk "hello" }
  end

  def test_talk_content
    gen_test('talk_content',       '    ', "hello\n") { talk "hello" }
    gen_test('talk_content_block', '    ', "hello\n") { talk { "hello" } }
  end

  def test_talk_block
    gen_test('talk', '    ', "hello\n") { talk { "hello" } }
    gen_test('talk', '  q ', false)     { talk { "hello" } }
    gen_test('talk', ' v  ', "hello\n") { talk { "hello" } }
    gen_test('talk', ' vq ', false)     { talk { "hello" } }
    gen_test('talk', 'n   ', "hello\n") { talk { "hello" } }
    gen_test('talk', 'n q ', false)     { talk { "hello" } }
    gen_test('talk', 'nv  ', "hello\n") { talk { "hello" } }
    gen_test('talk', 'nvq ', false)     { talk { "hello" } }
  end

  def test_talkf_arg
    #           nr, verb, quiet, output?
    gen_test('talkf_arg', '    ', true)    { talkf "%s", "hello" }
    gen_test('talkf_arg', '  q ', false)   { talkf "%s", "hello" }
    gen_test('talkf_arg', ' v  ', true)    { talkf "%s", "hello" }
    gen_test('talkf_arg', ' vq ', false)   { talkf "%s", "hello" }
    gen_test('talkf_arg', 'n   ', true)    { talkf "%s", "hello" }
    gen_test('talkf_arg', 'n q ', false)   { talkf "%s", "hello" }
    gen_test('talkf_arg', 'nv  ', true)    { talkf "%s", "hello" }
    gen_test('talkf_arg', 'nvq ', false)   { talkf "%s", "hello" }
  end

  def test_talkf_block
    #           nr, verb, quiet, output?
    gen_test('talkf_block', '    ', true)    { talkf("%s") { "hello" } }
    gen_test('talkf_block', '  q ', false)   { talkf("%s") { "hello" } }
    gen_test('talkf_block', ' v  ', true)    { talkf("%s") { "hello" } }
    gen_test('talkf_block', ' vq ', false)   { talkf("%s") { "hello" } }
    gen_test('talkf_block', 'n   ', true)    { talkf("%s") { "hello" } }
    gen_test('talkf_block', 'n q ', false)   { talkf("%s") { "hello" } }
    gen_test('talkf_block', 'nv  ', true)    { talkf("%s") { "hello" } }
    gen_test('talkf_block', 'nvq ', false)   { talkf("%s") { "hello" } }
  end

  def test_talkf_content
    gen_test('talkf_content',         '    ', "-hello-")  { talkf "-%s-",   "hello" }
    gen_test('talkf_content',         '    ', "-hello-")  { talkf("-%s-") { "hello" } }
    gen_test('talkf_content',         '    ', "-hello-")  { talkf { ["-%s-", "hello" ] } }
    gen_test('talkf_default_content', '    ', 'hello')    { talkf           "hello" }
    gen_test('talkf_default_content', '    ', 'hello')    { talkf         { "hello" } }
  end

  def test_qtalk_arg
    gen_test('qtalk', '    ', false)     { qtalk "hello" }
    gen_test('qtalk', '  q ', "hello\n") { qtalk "hello" }
    gen_test('qtalk', ' v  ', false)     { qtalk "hello" }
    gen_test('qtalk', ' vq ', "hello\n") { qtalk "hello" }
    gen_test('qtalk', 'n   ', false)     { qtalk "hello" }
    gen_test('qtalk', 'n q ', "hello\n") { qtalk "hello" }
    gen_test('qtalk', 'nv  ', false)     { qtalk "hello" }
    gen_test('qtalk', 'nvq ', "hello\n") { qtalk "hello" }
  end

  def test_qtalk_block
    gen_test('qtalk', '    ', false)     { qtalk { "hello" } }
    gen_test('qtalk', '  q ', "hello\n") { qtalk { "hello" } }
    gen_test('qtalk', ' v  ', false)     { qtalk { "hello" } }
    gen_test('qtalk', ' vq ', "hello\n") { qtalk { "hello" } }
    gen_test('qtalk', 'n   ', false)     { qtalk { "hello" } }
    gen_test('qtalk', 'n q ', "hello\n") { qtalk { "hello" } }
    gen_test('qtalk', 'nv  ', false)     { qtalk { "hello" } }
    gen_test('qtalk', 'nvq ', "hello\n") { qtalk { "hello" } }
  end

  def test_qtalk_content
    gen_test('qtalk_content', 'q', "hello\n") { qtalk "hello" }
    gen_test('qtalk_content', ' ',  false)    { qtalk "hello" }
    gen_test('qtalk_content', 'q', "hello\n") { qtalk { "hello" } }
    gen_test('qtalk_content', ' ',  false)    { qtalk { "hello" } }
  end

  def test_qtalkf_content
    gen_test('qtalkf_content',         'q', "-hello-") { qtalkf "-%s-",   "hello" }
    gen_test('qtalkf_content',         'q', "-hello-") { qtalkf("-%s-") { "hello" } }
    gen_test('qtalkf_content',         'q', "-hello-") { qtalkf { [ "-%s-",   "hello" ] } }
    gen_test('qtalkf_default_content', 'q', "hello")   { qtalkf           "hello" }
    gen_test('qtalkf_default_content', 'q', "hello")   { qtalkf         { "hello" } }
    gen_test('qtalkf_content',         ' ', false)     { qtalkf "-%s-",   "hello" }
    gen_test('qtalkf_content',         ' ', false)     { qtalkf("-%s-") { "hello" } }
    gen_test('qtalkf_default_content', ' ', false)     { qtalkf           "hello" }
    gen_test('qtalkf_default_content', ' ', false)     { qtalkf         { "hello" } }
  end

  def test_vtalk_arg
    gen_test('vtalk_arg', '    ', false)     { vtalk "hello" }
    gen_test('vtalk_arg', '  q ', false)     { vtalk "hello" }
    gen_test('vtalk_arg', ' v  ', "hello\n") { vtalk "hello" }
    gen_test('vtalk_arg', ' vq ', "hello\n") { vtalk "hello" }
    gen_test('vtalk_arg', 'n   ', false)     { vtalk "hello" }
    gen_test('vtalk_arg', 'n q ', false)     { vtalk "hello" }
    gen_test('vtalk_arg', 'nv  ', "hello\n") { vtalk "hello" }
    gen_test('vtalk_arg', 'nvq ', "hello\n") { vtalk "hello" }
  end

  def test_vtalk_block
    gen_test('vtalk_block', '    ', false)     { vtalk { "hello" } }
    gen_test('vtalk_block', '  q ', false)     { vtalk { "hello" } }
    gen_test('vtalk_block', ' v  ', "hello\n") { vtalk { "hello" } }
    gen_test('vtalk_block', ' vq ', "hello\n") { vtalk { "hello" } }
    gen_test('vtalk_block', 'n   ', false)     { vtalk { "hello" } }
    gen_test('vtalk_block', 'n q ', false)     { vtalk { "hello" } }
    gen_test('vtalk_block', 'nv  ', "hello\n") { vtalk { "hello" } }
    gen_test('vtalk_block', 'nvq ', "hello\n") { vtalk { "hello" } }
  end

  def test_nvtalk_arg
    gen_test('nvtalk_arg', '    ', "hello\n")  { nvtalk "hello" }
    gen_test('nvtalk_arg', '  q ', "hello\n")  { nvtalk "hello" }
    gen_test('nvtalk_arg', ' v  ', false)      { nvtalk "hello" }
    gen_test('nvtalk_arg', ' vq ', false)      { nvtalk "hello" }
    gen_test('nvtalk_arg', 'n   ', "hello\n")  { nvtalk "hello" }
    gen_test('nvtalk_arg', 'n q ', "hello\n")  { nvtalk "hello" }
    gen_test('nvtalk_arg', 'nv  ', false)      { nvtalk "hello" }
    gen_test('nvtalk_arg', 'nvq ', false)      { nvtalk "hello" }
  end

  def test_nvtalk_block
    gen_test('nvtalk_block', '    ', true)   { nvtalk { "hello" } }
    gen_test('nvtalk_block', '  q ', true)   { nvtalk { "hello" } }
    gen_test('nvtalk_block', ' v  ', false)  { nvtalk { "hello" } }
    gen_test('nvtalk_block', ' vq ', false)  { nvtalk { "hello" } }
    gen_test('nvtalk_block', 'n   ', true)   { nvtalk { "hello" } }
    gen_test('nvtalk_block', 'n q ', true)   { nvtalk { "hello" } }
    gen_test('nvtalk_block', 'nv  ', false)  { nvtalk { "hello" } }
    gen_test('nvtalk_block', 'nvq ', false)  { nvtalk { "hello" } }
  end

  def test_nrtalk_arg
    gen_test('nrtalk_arg', '    ', false)     { nrtalk "hello" }
    gen_test('nrtalk_arg', '  q ', false)     { nrtalk "hello" }
    gen_test('nrtalk_arg', ' v  ', false)     { nrtalk "hello" }
    gen_test('nrtalk_arg', ' vq ', false)     { nrtalk "hello" }
    gen_test('nrtalk_arg', 'n   ', true)      { nrtalk "hello" }
    gen_test('nrtalk_arg', 'n q ', true)      { nrtalk "hello" }
    gen_test('nrtalk_arg', 'nv  ', true)      { nrtalk "hello" }
    gen_test('nrtalk_arg', 'nvq ', true)      { nrtalk "hello" }
  end

  def test_nrtalk_prefix
    gen_test('nrtalk_prefix', 'n   ', "(norun) hello\n")    { nrtalk "hello" }
    gen_test('nrtalk_prefix', '    ', false)                { nrtalk "hello" }
    gen_test('nrtalk_prefix', 'n   ', "(norun) hello\n")    { nrtalk { "hello" } }
    gen_test('nrtalk_prefix', '    ', false)                { nrtalk { "hello" } }
  end

  def test_nrtalk_block
    gen_test('nrtalk_block', '    ', false)    { nrtalk { "hello" } }
    gen_test('nrtalk_block', '  q ', false)    { nrtalk { "hello" } }
    gen_test('nrtalk_block', ' v  ', false)    { nrtalk { "hello" } }
    gen_test('nrtalk_block', ' vq ', false)    { nrtalk { "hello" } }
    gen_test('nrtalk_block', 'n   ', true)     { nrtalk { "hello" } }
    gen_test('nrtalk_block', 'n q ', true)     { nrtalk { "hello" } }
    gen_test('nrtalk_block', 'nv  ', true)     { nrtalk { "hello" } }
    gen_test('nrtalk_block', 'nvq ', true)     { nrtalk { "hello" } }
  end

  def test_nrtalkf_content
    gen_test('nrtalkf_content',         'n   ', "(norun) -hello-") { nrtalkf "-%s-",   "hello" }
    gen_test('nrtalkf_content',         'n   ', "(norun) -hello-") { nrtalkf("-%s-") { "hello" } }
    gen_test('nrtalkf_default_content', 'n   ', "(norun) hello")   { nrtalkf           "hello" }
    gen_test('nrtalkf_default_content', 'n   ', "(norun) hello")   { nrtalkf         { "hello" } }

    gen_test('nrtalkf_content',         '    ', false)     { nrtalkf "-%s-",   "hello" }
    gen_test('nrtalkf_content',         '    ', false)     { nrtalkf("-%s-") { "hello" } }
    gen_test('nrtalkf_default_content', '    ', false)     { nrtalkf           "hello" }
    gen_test('nrtalkf_default_content', '    ', false)     { nrtalkf         { "hello" } }
  end

  def test_nrtalkf_prefix
    gen_test('nrtalkf_prefix',          'n   ', "(norun) -hello-") { nrtalkf "-%s-",   "hello" }
    gen_test('nrtalkf_prefix',          'n   ', "(norun) -hello-") { nrtalkf("-%s-") { "hello" } }
    gen_test('nrtalkf_default_content', 'n   ', "(norun) hello")   { nrtalkf           "hello" }
    gen_test('nrtalkf_default_content', 'n   ', "(norun) hello")   { nrtalkf         { "hello" } }
  end

  def test_dtalk_arg
    gen_test('dtalk_arg', '    ', false)     { dtalk "hello" }
    gen_test('dtalk_arg', '  q ', false)     { dtalk "hello" }
    gen_test('dtalk_arg', ' v  ', false)     { dtalk "hello" }
    gen_test('dtalk_arg', ' vq ', false)     { dtalk "hello" }
    gen_test('dtalk_arg', 'n   ', false)     { dtalk "hello" }
    gen_test('dtalk_arg', 'n q ', false)     { dtalk "hello" }
    gen_test('dtalk_arg', 'nv  ', false)     { dtalk "hello" }
    gen_test('dtalk_arg', 'nvq ', false)     { dtalk "hello" }

    gen_test('dtalk_arg', '   d', true)      { dtalk "hello" }
    gen_test('dtalk_arg', '  qd', true)      { dtalk "hello" }
    gen_test('dtalk_arg', ' v d', true)      { dtalk "hello" }
    gen_test('dtalk_arg', ' vqd', true)      { dtalk "hello" }
    gen_test('dtalk_arg', 'n  d', true)      { dtalk "hello" }
    gen_test('dtalk_arg', 'n qd', true)      { dtalk "hello" }
    gen_test('dtalk_arg', 'nv d', true)      { dtalk "hello" }
    gen_test('dtalk_arg', 'nvqd', true)      { dtalk "hello" }
  end

  def test_dtalk_block
    gen_test('dtalk_block', '   d', true)     { dtalk { "hello" } }
    gen_test('dtalk_block', '  qd', true)     { dtalk { "hello" } }
    gen_test('dtalk_block', ' v d', true)     { dtalk { "hello" } }
    gen_test('dtalk_block', ' vqd', true)     { dtalk { "hello" } }
    gen_test('dtalk_block', 'n  d', true)     { dtalk { "hello" } }
    gen_test('dtalk_block', 'n qd', true)     { dtalk { "hello" } }
    gen_test('dtalk_block', 'nv d', true)     { dtalk { "hello" } }
    gen_test('dtalk_block', 'nvqd', true)     { dtalk { "hello" } }
  end

  def test_dtalkf_content
    gen_test('dtalkf_content',         '   d', "-hello-") { dtalkf "-%s-",   "hello" }
    gen_test('dtalkf_content',         '   d', "-hello-") { dtalkf("-%s-") { "hello" } }
    gen_test('dtalkf_default_content', '   d', "hello")   { dtalkf           "hello" }
    gen_test('dtalkf_default_content', '   d', "hello")   { dtalkf         { "hello" } }

    gen_test('dtalkf_content',         '    ', false)     { dtalkf "-%s-",   "hello" }
    gen_test('dtalkf_content',         '    ', false)     { dtalkf("-%s-") { "hello" } }
    gen_test('dtalkf_default_content', '    ', false)     { dtalkf           "hello" }
    gen_test('dtalkf_default_content', '    ', false)     { dtalkf         { "hello" } }
  end

  def test_block_contents
    gen_test('talkf_content',         '   ', "-hello-there-") { talkf "-%s-%s-",   "hello", "there" }
    gen_test('talkf_content',         '   ', "-hello-there-") { talkf("-%s-%s-") { ["hello", "there" ] } }
    gen_test('talkf_content',         '   ', "-hello-there-") { talkf("-%s-%s-", "hello") { "there" } }
    gen_test('talkf_content',         '   ', "-hello-there-") { talkf("-%s-%s-", "hello") { [ "there" ]  } }
    gen_test('talkf_default_content', '   ', "-hello-there-") { talkf { [ "-%s-%s-", "hello", "there" ] } }
  end

end
# end of test-talk-utils.rb
