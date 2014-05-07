args_parser
===========

* Parse/Filter/Validate ARGV from command line with DSL.
* http://shokai.github.io/args_parser


Requirements
------------
- Ruby 1.8.7 ~ 2.0.0


Install
-------

    % gem install args_parser


Synopsis
--------

    % ruby samples/download_webpage.rb -url http://example.com -o out.html


parse ARGV
```ruby
require 'rubygems'
require 'args_parser'

args = ArgsParser.parse ARGV do
  arg :url, 'URL', :alias => :u
  arg :output, 'output file', :alias => :o, :default => 'out.html'
  arg :verbose, 'verbose mode'
  arg :help, 'show help', :alias => :h

  filter :url do |v|
    v.to_s.strip
  end

  validate :url, "invalid URL" do |v|
    v =~ /^https?:\/\/.+$/
  end
end

if args.has_option? :help or !args.has_param?(:url, :output)
  STDERR.puts args.help
  exit 1
end

require 'open-uri'
puts 'download..' if args[:verbose]
open(args[:output], 'w+') do |f|
  f.write open(args[:url]).read
end
puts "saved! => #{args[:output]}"
```

### equal style

    % ruby samples/equal_style.rb --help
    % ruby samples/equal_style.rb --user=shokai hello world  --a=1234

parse equal style ARGV
```ruby
args = ArgsArgs.parse ARGV, :style => :equal do
```

see more samples https://github.com/shokai/args_parser/tree/master/samples


Test
----

    % gem install bundler
    % bundle install
    % bundle exec rake test


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request