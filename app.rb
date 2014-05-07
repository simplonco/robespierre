require 'bundler'
Bundler.require
require 'sinatra'
Dotenv.load
require './model_vote'
require './model_tweet'
require './model_redis'

set :database, "sqlite3:///foo.sqlite3"

client = Twitter::REST::Client.new do |config|
	config.consumer_key        = ENV['CONSUMER_KEY']
	config.consumer_secret     = ENV['CONSUMER_SECRET']
	config.access_token        = ENV['ACCESS_TOKEN']
	config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

class Track < ActiveRecord::Base
	def self.destroy_from_title(title)
		`rm ./public/tracks/#{title}.mp3`
		# TODO destroy mp3 file
		#regarder les fileutils ruby
		Track.find_by_title(title).destroy
	end
end

enable :sessions #permet de stocker une variable dans une session et de pouvoir l'utiliser partout dans l'app

get '/' do
	@redis = Redis.new
	@new_array = []

	@redis.keys("robonova:tweet:*").each do |x|
		@new_array.push(JSON.parse(@redis.get(x)))
	end
	erb :index
end

post '/' do #avec tts
	input = params[:input] || params[:tweet].to_s
	input = input.gsub("&", "et ").
	gsub("@", "at ").
	gsub("#", "hachetague").
	gsub(/[$°_\"{}\]\[`~&+,:;=?@#|'<>.^*()%!-]/, "")
	if input.empty?
	else
		input.to_file "fr", "public/tracks/#{input[0..57]}.mp3"
		new_track = Track.new
		new_track.title = input[0..57]
		new_track.lien = "../tracks/#{input[0..57]}.mp3"
		new_track.save
	end
	redirect to ('/')
end

post '/search' do #pour chercher un mot ou hashtag sur twitter
	@redis = Redis.new
	@search = client.search("#{params[:input]}", :result_type => "recent").take(ENV['TWEET_SEARCH_LIMIT'].to_i)
	erb :search_page
end

post '/update_statut' do #pour poster un tweet
	client.update("#{params[:input]}")
	redirect to ('/2')
end

post '/sort_url' do
	params[:tracks].each do |track|
		index = track[0].to_i
		track_name = track[1][:title]
		Track.update_all({position: index+1}, {title: track_name})
	end
	Track.order("position").map do |track|
		{title: track.title, mp3: track.lien}
	end.to_json
end

post '/remove_track' do
	Track.destroy_from_title(params[:name])
end

post '/vote' do
	redis = Redis.new
	if redis.get("demarrer") == "off"
		redis.set "demarrer", "on"
	else
		redis.set "demarrer", "off"
	end
	redirect to '/'
end

post "/remettre_a_zero" do
	redis  =Redis.new
	redis.set "PSG", 0
	redis.set "obama", 0
	redis.set "justin bieber", 0
	redirect to '/'
end

post '/arduino' do
	arduino_controller = ArduinoControl.new(" blabla")
	arduino_controller.blink_ten_times(1.0)
end

post '/Usain_Bolt' do

	`ping brasgauche.com`
	`ping brasdroit.com`
	`ping tete.com`
	`ping wwww.lemonde.fr`
	erb :index
end

#gem forman
#cette ligne sert uniquement de test et peut être supprimé n'importe quand
