require 'bundler'
Bundler.require
require 'sinatra'
Dotenv.load
require './model_vote'
require './model_tweet'
require './model_redis'
require './methods.rb'

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
		#regarder les fileutils ruby pour supprimer en ruby plutôt que de rentrer dans le schell
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

post '/' do #avec tts => pour envoyer des éléments des blocs tweet et TTS vers le player audio
	input = params[:input] || params[:tweet].to_s
	if input != nil
		no_special_caracters(input).to_file "fr", "public/tracks/#{input[0..57]}.mp3"
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
	puts params[:tracks]
	params[:tracks].each do |index, track|
		puts "index: #{index} track: #{track} title: #{track[:title]}"
		Track.where({position: index.to_i + 1}).update_all({title: track[:title]})
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

get "/update_vote" do
	redis = Redis.new
	if redis.get("demarrer") == "off"
		"stop polling".to_json
	else
		{vote_1: redis.get('PSG'), 
			vote_2: redis.get('obama'), 
			vote_3: redis.get('justin bieber')}.to_json
	end
end

post "/remettre_a_zero" do
	redis  = Redis.new
	redis.set "PSG", 0
	redis.set "obama", 0
	redis.set "justin bieber", 0
end

post '/arduino' do #test
	arduino_controller = ArduinoControl.new(" blabla")
	arduino_controller.blink_ten_times(1.0)
end

post '/Usain_Bolt' do #fonctionnalité en cours de dévelloppement. Pour
					  #actionner les mouvement du robot à partir de l'app.
					  #l'app enverra une requête à un serveur qui selon la requête
					  #enverra diférentes instructions aux cerveaux moteurs
					  `ping brasgauche.com`
					  `ping brasdroit.com`
					  `ping tete.com`
					  `ping wwww.lemonde.fr`
					  erb :index
					end

#penser à faire un player voix du robot pour que les actions n'empiètent
#pas sur la playlist de voix