require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestArgsParserOn < MiniTest::Test

  def test_filter_error
    argv = ['--h', '--say', 'hello']
    help_called = false
    say_called = false
    args = ArgsParser.parse argv do
      arg :help, 'show help', :alias => :h
      arg :say, 'string'

      on :say do |v|
        say_called = v
      end

      on :help do
        help_called = true
      end
    end

    assert_equal say_called, "hello"
    assert_equal help_called, true
  end

end
