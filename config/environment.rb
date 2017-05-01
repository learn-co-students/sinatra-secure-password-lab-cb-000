ENV["SINATRA_ENV"] ||= 'development'

require 'bundler'
Bundler.require(:default, ENV['SINATRA_ENV'])

configure do
	set :database, {adapter: "sqlite3", database: "db/#{ENV["SINATRA_ENV"]}.sqlite3"}
end

require_all 'app'
