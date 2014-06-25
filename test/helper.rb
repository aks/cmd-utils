# test/helper.rb

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest'
require 'minitest/autorun'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

module IO_Assert
  def io_assert ioname, name, actual, expected
    if expected
      case expected
      when TrueClass  then refute_empty(actual, "#{name} $#{ioname} should not be empty")
      when FalseClass then assert_empty(actual, "#{name} $#{ioname} should be empty")
      when String     then assert_match(actual, expected, "#{name} $#{ioname}: expected '#{expected}', got: '#{actual}'")
      end
    end
    true
  end
end

module Gen_Test
  include IO_Assert

  #def gen_test name, norun, verbose, quiet, debug, output
  def gen_test name, flags, output
    $norun   = flags.include?('n')
    $verbose = flags.include?('v')
    $quiet   = flags.include?('q')
    $debug   = flags.include?('d')
    out, err = capture_io { yield }
    assert_empty(out, "#{name} $stdout should be empty")
    io_assert :stderr, name, err, output
  end
end

module Run_Test
  include IO_Assert
  def run_test name, flags, output=nil, errput=nil
    $norun   = flags.include?('n')
    $verbose = flags.include?('v')
    $quiet   = flags.include?('q')
    $debug   = flags.include?('d')
    begin
      out, err = capture_subprocess_io do
        begin
          yield
        rescue
        end
      end
    rescue
    end
    io_assert :stdout, name, out, output
    io_assert :stderr, name, err, errput
    true
  end
end

class Minitest::Test
end
