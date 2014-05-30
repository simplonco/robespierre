require 'twitter'
require './model_vote'
require 'sinatra/activerecord'
require 'redis'
require 'dotenv'
Dotenv.load
require 'pry'

client = Twitter::Streaming::Client.new do |config|
	config.consumer_key        = ENV['CONSUMER_KEY']
	config.consumer_secret     = ENV['CONSUMER_SECRET']
	config.access_token        = ENV['ACCESS_TOKEN']
	config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

keys = ["PSG", "obama", "justin bieber"]

counter1 = 0
counter2 = 0
counter3 = 0

systeme_vote = Vote
systeme_vote.set "demarrer", "off"

vote1 = Vote
vote1.set "PSG", 0
vote2 = Vote
vote2.set "obama", 0
vote3 = Vote
vote3.set "justin bieber", 0

loop do
	if systeme_vote.get("demarrer") == "on"
		client.filter(:track => "PSG, obama, justin bieber" ) do |object|
			if object.text.include?"PSG"
				puts "PSG +1"
				counter1 += 1
				vote1.set "PSG", "#{counter1}"
			elsif object.text.include?"obama"
				puts "obama +1"
				counter2 += 1
				vote2.set "obama", "#{counter2}"
			elsif object.text.include?"justin bieber"
				puts "justin bieber +1"
				counter3 += 1
				vote3.set "justin bieber", "#{counter3}"
			end
			if systeme_vote.get("demarrer") == "off"
				break
			end
		end
		sleep(5)
	end
end