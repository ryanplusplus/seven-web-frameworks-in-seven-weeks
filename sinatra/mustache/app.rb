require 'sinatra'
require 'sinatra/mustache'

get '/' do
	@bookmarks = get_all_bookmarks
	mustache :bookmark_list
end
