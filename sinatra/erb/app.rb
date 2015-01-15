require "sinatra"
require "data_mapper"
require "dm-serializer"
require "sinatra/respond_with"
require_relative "bookmark"

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/bookmarks.db")
DataMapper.finalize.auto_upgrade!

class Hash
  def slice(*whitelist)
    whitelist.inject({}) {|result, key|
      result.merge(key => self[key])
    }
  end
end

def get_all_bookmarks
  Bookmark.all(:order => :title)
end

get "/" do
  @bookmarks = get_all_bookmarks
  erb :bookmark_list
end

get "/bookmarks" do
  @bookmarks = get_all_bookmarks
  respond_with :bookmark_list, @bookmarks
end

get "/bookmark/new" do
  erb :bookmark_form_new
end

get "/bookmarks/:id" do
  id = params[:id]
  @bookmark = Bookmark.get(id)
  respond_with :bookmark_form_edit, @bookmark
end

post "/bookmarks" do
  input = params.slice "url", "title"
  bookmark = Bookmark.create input
  respond_to do |f|
    f.html { redirect "/" }
    f.json { [201, "/bookmarks/#{bookmark['id']}"] }
  end
end

put "/bookmarks/:id" do
  id = params[:id]
  bookmark = Bookmark.get(id)
  input = params.slice "url", "title"
  bookmark.update input
  204
  respond_to do |f|
    f.html { redirect "/" }
    f.json { 204 }
  end
end

delete "/bookmarks/:id" do
  id = params[:id]
  bookmark = Bookmark.get(id)
  bookmark.destroy
  respond_to do |f|
    f.html { redirect "/" }
    f.json { 200 }
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
