require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

def parser(type,movie)
	parser = JSON.parse(Typhoeus.get("omdbapi.com", :params => {type => movie}).body)
end

get "/" do
erb :search
end

post "/results" do
	redirect "/" if params[:movie] == ""
	@movies = parser(:s,params[:movie])['Search'].map! do |movie| 
		movie = parser(:i,movie['imdbID'])
	end
	erb :test_results
end