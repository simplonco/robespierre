require File.expand_path 'test_helper', File.dirname(__FILE__)
require 'json'

class TestArgsParserFilter < MiniTest::Test
  def setup
    @argv = ['--count', '35', '--data', '["say","hello"]']
    @@err = nil
    @@name = nil
    @@value = nil
    @parser = ArgsParser.parse @argv do
      arg :data, 'json data'
      arg :count, 'number'

      filter :data do |v|
        JSON.parse v
      end

      filter :count do |v|
        raise NoMethodError, 'error!!'
      end

      on_filter_error do |err, name, value|
        @@err = err
        @@name = name
        @@value = value
      end
    end
  end

  def test_filter_error
    assert @parser.has_param? :data
    assert @parser.has_param? :count
    assert_equal @@name, :count
    assert_equal @@value, '35'
    assert_equal @@err.class, NoMethodError
  end
end
