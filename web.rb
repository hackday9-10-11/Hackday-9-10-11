require 'sinatra'
require 'json'
require 'mongo'
require 'net/http'

set :public, File.dirname(__FILE__) + '/www'

get '/hotels' do

	api = 'xp9m6tekaqpy8fqzd8qahyre';
	url = 'http://api.ean.com/ean-services/rs/hotel/v3/list?cid=55505&apiKey=' + api + '&locale=en_US&currencyCode=USD&latitude=' + params[:lat] + '&longitude=' + params[:lng];
	response = http.request_get(url);
	return response.body
end


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
