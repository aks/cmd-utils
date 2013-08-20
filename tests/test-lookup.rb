#!/usr/bin/env ruby
# test-cmd-utils.rb -- simple tester for cmd-utils
#
require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require 'lookup'

class NilClass ; def to_s ; '' ; end ; end

class TestLookup < MiniTest::Test

  def do_lookup input, output, errok=nil
    found = nil
    err = ''
    begin
      found = lookup(@keywords, input)
      found = found.first if found && found.size == 1
    rescue LookupError  => err
    end
    if errok
      refute_empty err.to_s, "Input = #{input}\nErr = #{err.to_s}\n"
    else
      assert_empty err.to_s, "Input = #{input}\nErr = #{err}\n"
      assert_equal found, output, "Input = #{input}\nOutput = #{output}\n"
    end
  end

  def test_lookup_many
    @keywords = %w( set get show edit reset delete count )
    do_lookup 'se',   'set'
    do_lookup 'set',  'set'
    do_lookup 'SET',  'set'
    do_lookup 'show', 'show'
    do_lookup 'sh',   'show'
    do_lookup 'e',    'edit'
    do_lookup 'ed',   'edit'
    do_lookup 's',    [%w( set show )], true
  end

  def test_lookup_exact
    @keywords = %w( email emails reason reasons )
    do_lookup 'email',  'email'
    do_lookup 'emails', 'emails'
    do_lookup 'emai',   'email',  true
    do_lookup 'rea',    'reason', true
    do_lookup 'reason', 'reason'
    do_lookup 'reasons', 'reasons'
  end

end
