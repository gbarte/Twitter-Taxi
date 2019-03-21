require 'erb'
require 'sinatra'
#require 'sinatra/reloader'
require 'sqlite3'
require 'twitter'

set :bind, '0.0.0.0' # needed if you're running from Codio

include ERB::Util

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

before do
    @db = SQLite3::Database.open './database.db'
end
    config = {
        :consumer_key => 'lqCpGOUMYGXaSLMAYUyqH9MhX',
        :consumer_secret => 'aMUTzyD8UlzcHqyWTtgrgNA6L7LKy9tL6WP7jCRCrVVxYzJa1D',
        :access_token => '1092447528761610240-sKtozZ8IDihSED4UuFK2fk39bWNCa7',
        :access_token_secret => 'CbNNmZHlIZJSttTk3OlAhZ4vdfE9BJtv0iBDYGy8YHar7'
    }

    client = Twitter::REST::Client.new(config)

get '/index' do
    erb :index
end

get '/admin' do
    @submitted = false
    puts "printed to the terminal" 
    erb :admin
end

########## finish admin login ###########
post '/admin' do
  # puts "printed to the terminal" 
   @submitted = true
   @email = params[:mail]
   puts @email
   @password = params[:psw]
    
   #query = %{SELECT * FROM Admins WHERE email_address LIKE '%#{params[:mail]}%'}
   query = %{SELECT email_address FROM Admins WHERE email_address LIKE '%#{params[:mail]}%'}

   @results = @db.execute query
   puts @results
   puts "searched through the database"
   if (@results==1)
       puts "the email addresses are the same"
       erb :adminlogin
   else
       puts "different email addresses"
       erb :index
   end
  # erb :index
end


get '/customer' do
    ######fix for login
    unless params[:username].nil?
    #unless params[:username].nil? && params[:psw].nil?
        query = %{SELECT twitterHandle FROM UserInfo WHERE twitterHandle LIKE '%#{params[:username]}%'}
        @results = @db.execute query
    end
    erb :customer
end

get '/adminhomepage' do
    erb :adminlogin
end

get '/orderhistory' do
    erb :orderhistory
end

get '/signup' do
    @submitted = false
    erb :signup
end

post '/form_handler' do
    @submitted=true
    @fname = params[:fname].strip
    @lname = params[:lname].strip
    @tname = params[:tname].strip
    @psw = params[:psw].strip
    @mail = params[:mail].strip
 
    #perform validation
  
    @fname_ok =!@fname.nil? && @fname != "" 
    @lname_ok =!@lname.nil? && @lname != "" 
    @tname_ok =!@tname.nil? && @tname != ""
    @mail_ok =!@mail.nil? && @mail =~ VALID_EMAIL_REGEX
    
    count = @db.get_first_value('SELECT COUNT(*) FROM UserInfo WHERE firstName = ?
        AND lastName = ?',[@fname,@lname])
    @unique = (count == 0)
    @all_ok = @fname_ok && @lname_ok && @tname_ok && @mail_ok
    
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

get '/currentorders' do
    @submitted = false
    erb :currentorders
end

post '/currentorders' do
    @submitted = true
    @tname = params[:tname].strip
    @pickuplocation = params[:pickuplocation].strip
    @destination = params[:destination].strip
    @datetime = params[:datetime].strip
    @tier_id = params[:tier_id].strip
    
    user_id = @db.execute('SELECT user_id FROM UserInfo WHERE twitterHandle = ?', [@tname])
    
    @db.execute('INSERT INTO CurrentOrders VALUES (?,?,?,?,?)',[user_id,@pickuplocation,@destination,@datetime.to_s,@tier_id])
    
    erb :currentorders
end

get '/addnewadmin' do
    @submitted = false
    erb :addnewadmin
end

post '/addnewadmin' do 
    @submitted = true
    @email = params[:email].strip
    @psw = params[:psw].strip 
    
    admin_id = @db.get_first_value 'SELECT MAX(admin_id)+1 FROM Admins'
    
    @db.execute('INSERT INTO Admins VALUES (?, ?, ?)', [admin_id, @email, @psw])
    
    erb :addnewadmin
end

get '/viewincomingtweets' do
    results = client.search('@ise19team09')
    @tweets = results.take(20)
    erb :viewincomingtweets
end