# app.rb
require 'sinatra'
require 'tts'
require 'pry'
require 'pry-debugger'
require 'dotenv'
Dotenv.load
require 'twitter'


client = Twitter::REST::Client.new do |config|
	config.consumer_key        = ENV['CONSUMER_KEY']
	config.consumer_secret     = ENV['CONSUMER_SECRET']
	config.access_token        = ENV['ACCESS_TOKEN']
	config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end


get '/' do
	@user_mentions  = client.mentions_timeline

	erb :index
end

post '/' do #avec espeak
	@tweets = "#{params[:tweet]}"
	`espeak -v fr '#{params[:input]}'`
	redirect to ('/')
end

get '/1' do
	erb :page1
end

post '/1' do #avec tts
	"#{params[:input]}".to_file "fr", 'input.mp3'
	`cvlc --play-and-exit "input.mp3" && rm input.mp3`
	redirect to ('/1')
end

get '/2' do
	@user_timeline = client.user_timeline
	erb :page2
end

post '/2' do
	redirect to ('/2')
end

post '/3' do
	@search = client.search("#{params[:input]}")
	erb :page3
end

post '/4' do
	client.update("#{params[:input]}")
	redirect to ('/2')
end