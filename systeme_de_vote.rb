require 'twitter'
require './model_vote'
require 'sinatra/activerecord'
require 'sqlite3'
require 'dotenv'
Dotenv.load

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

keys = ["PSG", "obama", "justin bieber"]
vote1 = Vote.find_by_id(167)
vote1.save
counter1 = 0
vote2 = Vote.find_by_id(168)
vote2.save
counter2 = 0
vote3 = Vote.find_by_id(169)
vote3.save
counter3 = 0

client.filter(:track => "PSG, obama, justin bieber" ) do |object|
	if object.text.include?"obama"
		counter1 += 1
		vote1.counter = counter1
		vote1.save
	elsif object.text.include?"PSG"
		counter2 += 1
		vote2.counter = counter2
		vote2.save
	elsif object.text.include?"justin bieber"
		counter3 += 1
		vote3.counter = counter3
		vote3.save
	end
end