#!/usr/bin/env ruby
## sample app

$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'args_parser'

args = ArgsParser.parse ARGV do
  arg :url, 'URL', :alias => :u
  arg :output, 'output file', :alias => :o, :default => 'out.html'
  arg :verbose, 'verbose mode'
  arg :time, 'time', :default => lambda{ Time.now }
  arg :help, 'show help', :alias => :h

  filter :url do |v|
    v.to_s.strip
  end

  validate :url, "invalid URL" do |v|
    v =~ /^https?:\/\/.+$/
  end
end

if args.has_option? :help or !args.has_param?(:url, :output)
  STDERR.puts "Download WebPage\n=="
  STDERR.puts args.help
  STDERR.puts "e.g.  ruby #{$0} -url http://example.com -o out.html"
  exit 1
end

p args

require 'open-uri'

puts 'download..' if args[:verbose]
data = open(args[:url]).read
puts data if args[:verbose]

open(args[:output], 'w+') do |f|
  f.write data
end
puts "saved! => #{args[:output]}"
