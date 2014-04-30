require 'twitter'
require './model_tweet'
require 'sinatra/activerecord'
require 'sqlite3'
require 'dotenv'
Dotenv.load
require'pry'

ActiveRecord::Base.establish_connection(
	:adapter => 'sqlite3',
	:database => 'foo.sqlite3'
	)

client = Twitter::Streaming::Client.new do |config|
	config.consumer_key        = ENV['CONSUMER_KEY']
	config.consumer_secret     = ENV['CONSUMER_SECRET']
	config.access_token        = ENV['ACCESS_TOKEN']
	config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

client.filter(:track => "PSG") do |object|
	if object.is_a?(Twitter::Tweet)
		tweet = Tweet.new
		tweet.author_name = object.user[:name] 
		tweet.content = object.text
		tweet.profile_image_url = object.user[:profile_image_url].to_s
		tweet.created_at = object.created_at
		tweet.save
	end
end