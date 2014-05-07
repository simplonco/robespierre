require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestArgsParserDefault < MiniTest::Test
  def setup
    @argv = ['--age', '40']
    @parser = ArgsParser.parse @argv do
      arg :name, 'use name', :default => 'shokai'
      arg :age, 'age', :default => 14
      arg :time, 'time', :default => lambda{ Time.now }
    end
  end

  def test_default
    assert_equal @parser[:name], 'shokai'
  end

  def test_overwrite
    assert_equal @parser[:age], 40
  end

  def test_name
    old = @parser[:time]
    sleep 1
    assert old < @parser[:time]
  end
end
