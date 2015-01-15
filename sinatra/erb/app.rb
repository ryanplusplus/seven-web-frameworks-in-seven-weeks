require "sinatra"
require "data_mapper"
require "dm-serializer"
require "sinatra/respond_with"
require_relative "bookmark"

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bookmarks.db")
DataMapper.finalize.auto_upgrade!

def get_all_bookmarks
  Bookmark.all(:order => :title)
end

get "/" do
  @bookmarks = get_all_bookmarks
  erb :bookmark_list
end
