require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

# build homepage
get "/" do

erb :search

end

post "/results" do

	to_search = params[:movie] # == "Cars"

	search_result = Typhoeus.get("www.omdbapi.com/",:params => {:s => to_search})
	@movie_list = JSON.parse(search_result.body)['Search'].sort_by {|movie| movie['Year']}

	#add the movie posters to the hashes:
	@movie_list.each do |movie|
		poster_search = Typhoeus.get("www.omdbapi.com/i=#{movie['imdbID']}")
		# Categories:
		# Title, Year, Rated, Released, Runtime, Genre, Director, Writer, Actors, Plot, Language, Country, Awards, Poster, Metascore, imdbRating, imdbVotes, imdbID, Type, Response
		info = JSON.parse(search_result.body)
		movie['Poster'] = info['Poster']
		movie['Plot'] = info['Plot']
	end


	erb :test_results

end