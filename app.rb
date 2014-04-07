require 'bundler'
Bundler.require
require 'sinatra'
Dotenv.load

set :database, "sqlite3:///foo.sqlite3"

client = Twitter::REST::Client.new do |config|
	config.consumer_key        = ENV['CONSUMER_KEY']
	config.consumer_secret     = ENV['CONSUMER_SECRET']
	config.access_token        = ENV['ACCESS_TOKEN']
	config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

class Track < ActiveRecord::Base
end

enable :sessions #permet de stocker une variable dans une session et de pouvoir l'utiliser partout dans l'app

helpers do #regarder comment créer un helper sur sinatra
	def foo
		"foo"
	end
end

get '/' do
	@user_mentions  = client.mentions_timeline
	erb :index
	# binding.pry
end

post '/' do #avec tts
	"#{params[:input]}".to_file "fr", "public/#{params[:input]}.mp3"
	redirect to ('/')
	#{}`cvlc --play-and-exit "input.mp3" && rm input.mp3`
end

get '/2' do
	@user_timeline = client.user_timeline
	erb :page2
end

post '/2' do
	redirect to ('/2')
end

post '/search' do #pour chercher un mot o ou hashtag sur twitter
	@search = client.search("#{params[:input]}")
	erb :search_page
end

post '/update_statut' do #pour poster un tweet
	client.update("#{params[:input]}")
	redirect to ('/2')
end

post '/5' do #envoie vers le player
	redirect to ('/')
end

# post '/6' do #envoie les morceaux de la playlist au player
# 	session[:track] = params[:track].gsub(/"\[\]/, '').gsub(',', '|')
# 	redirect to ('/2')
# end

post '/arduino' do
	arduino_controller = ArduinoControl.new(" blabla")
	arduino_controller.blink_ten_times(1.0)
end

post '/sort_url' do
	params[:tracks].each_with_index do |track_name, index|
		Track.update_all({position: index+1}, {title: track_name})
	end
	Track.order("position").map do |track|
		{title: track.title, mp3: track.lien}
	end.to_json
end
