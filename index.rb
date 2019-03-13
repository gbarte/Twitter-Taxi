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

post '/signup' do
    @submitted=true
    @fname = params[:fname]
    puts(@fname)
    
    # db.execute('')
    
    #perform validation
    @fname_ok =!@fname.nil? && @fname != "" 
    #not sure is this should be @db.fistname
    count = @db.firstname('SELECT COUNT(*) FROM UserInfo WHERE firstName = ?',[@fname])
    @unique = (count = 0)
    @all_ok=@fname_ok
    
    #add first name into database.
    if @all_ok = @fname
        #get next available ID
        id=@db.firstname 'SELECT MAX(id)+1 FROM UserInfo';
        #do the insert
        @db.execute('INSERT INTO UserInfo VALUES (?)',[id,@fname])
    end
    erb :add
    
    
    #putting erb :index here ensures that user is directed back to homepage after 
    #inputting sign up details
    erb :index

end


#get links to customer, admin, and signup page to work from here
