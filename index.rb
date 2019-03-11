#require 'erb'
require 'sinatra'
#require 'sinatra/reloader'
set :bind, '0.0.0.0' # needed if you're running from Codio

get '/index' do
    erb :index
end

get '/admin' do
    erb :admin
end

get '/customer' do
    erb :customer
end

get '/signup' do
    erb :signup
end




#get links to customer, admin, and signup page to work from here
