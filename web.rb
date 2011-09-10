require 'sinatra'
require 'json'
require 'mongo'

set :public, File.dirname(__FILE__) + '/www'



post '/found_trail_magic' do
	uri = URI.parse(ENV['MONGOHQ_URL'])
	conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
	db = conn.db(uri.path.gsub(/^\//, ''))
	coll = db.collection("magic");

	  magic = Hash.new
	  magic["lat"] = params[:lat];
	  magic["lng"] = params[:lng];
	  magic["contents"] = params[:contents];
	  coll.insert magic
	  redirect '/index.html'
end

get '/trail_magic.json' do
	content_type :json

	uri = URI.parse(ENV['MONGOHQ_URL'])
	conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
	db = conn.db(uri.path.gsub(/^\//, ''))
	coll = db.collection("magic");
	
	coll.find().to_a.to_json
end
