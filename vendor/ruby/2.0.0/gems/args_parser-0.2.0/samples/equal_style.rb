$:.unshift File.expand_path '../lib', File.dirname(__FILE__)

require 'args_parser'

args = ArgsParser.parse ARGV, :style => :equal do
  arg :help, 'show help', :alias => :h

  on :help do |v|
    STDERR.puts help
    STDERR.puts "e.g.  ruby equal_style.rb --user=shokai hello world  --a=1234"
    exit 1
  end
end

puts "== args"
p args
puts "== args.argv"
p args.argv
