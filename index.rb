#require 'erb'
require 'sinatra'
#require 'sinatra/reloader'
set :bind, '0.0.0.0' # needed if you're running from Codio

get '/index' do
    erb :index
end