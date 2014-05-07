require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestArgsParser < MiniTest::Test
  def setup
    @argv = 'test --input http://shokai.org -a --o ./out -h --depth 030 foo bar --pi 3.14 --n ShoKaI'.split(/\s+/)
    @parser = ArgsParser.parse @argv do
      arg :input, 'input', :alias => :i
      arg 'output', 'output dir', :alias => :o
      arg :name, 'user name', :alias => :n
      arg :help, 'show help', :alias => :h

      filter :name do |v|
        v.downcase
      end

      validate :input, "input must be valid URL" do |v|
        v =~ /^https?:\/\/.+/
      end
    end
  end

  def test_first
    assert_equal @parser.first, 'test'
  end

  def test_argv
    assert_equal @parser.argv, ['test', 'foo', 'bar']
  end

  def test_arg
    assert_equal @parser[:input], 'http://shokai.org'
  end

  def test_alias
    assert_equal @parser[:output], './out'
  end

  def test_string_access
    assert_equal @parser['output'], './out'
  end

  def test_cast_integer
    assert_equal @parser[:depth], 30
    assert_equal @parser[:depth].class, Fixnum
  end

  def test_cast_float
    assert_equal @parser[:pi], 3.14
    assert_equal @parser[:pi].class, Float
  end

  def test_filter
    assert_equal @parser[:name], 'shokai'
  end

  def test_missing_arg
    assert_equal @parser[:b], nil
  end

  def test_switch
    assert_equal @parser[:help], true
  end

  def test_has_param?
    assert @parser.has_param? :input
    assert @parser.has_param? :output
    assert @parser.has_param? 'output'
    assert @parser.has_param? :depth
    assert @parser.has_param? :pi
    assert @parser.has_param? :name
  end

  def test_has_params?
    assert @parser.has_param? :input, :output, 'depth', :pi, :name
  end

  def test_has_not_param?
    assert !@parser.has_param?(:a)
  end

  def test_has_option?
    assert @parser.has_option? :help
    assert @parser.has_option? 'help'
    assert @parser.has_option? :a
  end

  def test_has_options?
    assert @parser.has_option? :help, 'a'
  end

  def test_has_not_option?
    assert !@parser.has_option?(:b)
  end
end
