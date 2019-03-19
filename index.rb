require 'erb'
require 'sinatra'
#require 'sinatra/reloader'
require 'sqlite3'

set :bind, '0.0.0.0' # needed if you're running from Codio

include ERB::Util

before do
    @db = SQLite3::Database.open './database.db'
end

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
    @submitted = false
    erb :signup
end

post '/signup' do
    @submitted=true
    @fname = params[:fname]
    @lname = params[:lname]
    @tname = params[:tname]
    @psw = params[:psw]
    @mail = params[:mail]
    puts(@fname)
    
    #perform validation
  
    @fname_ok =!@fname.nil? && @fname != "" 
    @lname_ok =!@lname.nil? && @lname != "" 
    
    count = @db.get_first_value('SELECT COUNT(*) FROM UserInfo WHERE firstName = ?
        AND lastName = ?',[@fname,@lname])
    @unique = (count == 0)
    @all_ok=@fname_ok && @lname_ok
    
    #add data into the database.
    if @all_ok
        #get next available ID
        #NOTE: get_first_value is a method which belongs to @db
        user_id=@db.get_first_value 'SELECT MAX(user_id)+1 FROM UserInfo';
        #do the insert
        @db.execute('INSERT INTO UserInfo VALUES (?,?,?,?,?,?)',[user_id,@fname,@lname,@tname,@mail,@psw])
    end

    
    #putting erb :index here ensures that user is directed back to homepage after 
    #inputting sign up details
    #erb :index
    erb :signup
    
end

#get links to customer, admin, and signup page to work from here
