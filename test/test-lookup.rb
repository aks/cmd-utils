#!/usr/bin/env ruby
# test-cmd-utils.rb -- simple tester for cmd-utils
#
$:.unshift '.', 'lib'

require 'rubygems'
require 'helper'

require 'lookup'

class NilClass ; def to_s ; '' ; end ; end

class TestLookup < Minitest::Test

  # do_lookup input-text, output-text, true-if-notfound, true-if-ambiguous

  def do_lookup input, output, notfound=nil, ambig=nil
    found = nil
    if notfound
      assert_raises(LookupNotFoundError) {
        found = lookup(@keywords, input)
      }
    elsif ambig
      assert_raises(LookupAmbigError)    {
        found = lookup(@keywords, input)
      }
    else
      found = lookup(@keywords, input)
      #found = found.first if found && found.size == 1
      assert_equal found, output, "Input = #{input}\nOutput = #{output}\n"
    end
  end

  def test_lookup_many
    @keywords = %w( set get show edit reset delete count )
    do_lookup 'se',   'set'
    do_lookup 'set',  'set'
    do_lookup 'SET',  'set'
    do_lookup 'show', 'show'
    do_lookup 'showme', nil, true
    do_lookup 'sh',   'show'
    do_lookup 'e',    'edit'
    do_lookup 'ed',   'edit'
    do_lookup 's',    [%w( set show )], nil, true
  end

  def test_lookup_exact
    @keywords = %w( email emails reason reasons )
    do_lookup 'email',  'email'
    do_lookup 'emails', 'emails'
    do_lookup 'emai',   '',  nil, true   # ambiguous
    do_lookup 'rea',    '',  nil, true   # ambiguous
    do_lookup 'reason', 'reason'
    do_lookup 'reasons', 'reasons'
  end

  def test_lookup_failures
    @keywords = %w( set get show edit reset delete count )
    do_lookup "s", nil, nil, true   # ambigous
    do_lookup "foo", nil, true      # not found
    do_lookup "showit", nil, true   # not found
    do_lookup "rest",   nil, true   # not found
  end

end
