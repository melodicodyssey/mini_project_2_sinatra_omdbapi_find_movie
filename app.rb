require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

def omdb_typh_get(type,movie)
	Typhoeus.get("omdbapi.com", :params => {type => movie})
end

# build homepage
get "/" do

erb :search

end


post "/results" do
	#establish string to search for:
	to_search = params[:movie] # == "Star Wars"

	#query omdb, parse results, and do refined search with more info:
	result = omdb_typh_get(:s,to_search)
	@movie_list = JSON.parse(result.body)['Search'].map! do |movie|
		refined_search = omdb_typh_get(:i,movie['imdbID'])
		info = JSON.parse(refined_search.body)
		movie = info
	end

	erb :test_results

end