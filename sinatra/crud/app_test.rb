require_relative "app"
require "rspec"
require "rack/test"
require "json"

describe "Bookmarking App" do
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	it "creates a new bookmark" do
		get "/bookmarks"
		bookmarks = JSON.parse(last_response.body)
		last_size = bookmarks.size
		post "/bookmarks", {:url => "http://www.test.com", :title => "Test"}

	  expect(last_response.status).to be 201
	  expect(last_response.body).to match(/\/bookmarks\/\d+/) # (2)

	  get "/bookmarks"
	  bookmarks = JSON.parse(last_response.body)
	  expect(bookmarks.size).to eq(last_size + 1) # (3)
	end
end
