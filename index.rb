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
    
    # db.execute('')
    
    #perform validation
  
##    @fname_ok =!@fname.nil? && @fname != "" 
    #not sure is this should be @db.fistname
    #count = @db.database('SELECT COUNT(*) FROM UserInfo WHERE firstName = ?',[@fname])
    #@unique = (count = 0)
##    @all_ok=@fname_ok
    
    #add first name into database.
##    if @all_ok = @fname
        #get next available ID
        # the method get_first_value value if undefined here. Fix.
        user_id=@db.get_first_value 'SELECT MAX(user_id)+1 FROM UserInfo';
        #do the insert
        @db.execute('INSERT INTO UserInfo VALUES (?,?,?,?,?,?)',[user_id,@fname,@lname,@tname,@psw,@mail])
##    end
    
##    erb :add
    
    
    #putting erb :index here ensures that user is directed back to homepage after 
    #inputting sign up details
    #erb :index
    erb :signup
    

end


#get links to customer, admin, and signup page to work from here
