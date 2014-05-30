#pour afficher le fil twitter du robot qui sera sur la page index
require 'twitter'
require './model_tweet'
require 'sinatra/activerecord'
require 'dotenv'
Dotenv.load
require 'pry'
require './model_redis'

client = Twitter::Streaming::Client.new do |config|
	config.consumer_key        = ENV['CONSUMER_KEY']
	config.consumer_secret     = ENV['CONSUMER_SECRET']
	config.access_token        = ENV['ACCESS_TOKEN']
	config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

counter = 0
client.filter(:track => "obama", :lang => "fr") do |object|
	if object.is_a?(Twitter::Tweet)
		counter += 1
		tweet = Redis.new
		tweet.set "robonova:tweet:#{counter}", {author_name: object.user[:name], 
			status: object.text,
			profile_image_url: object.user.profile_image_url.to_s}.to_json
		tweet.save
	end
	if counter >= ENV['TWEET_LIMIT'].to_i
		counter = 0
	end
end
