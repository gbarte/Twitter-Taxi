require 'erb'
require 'sinatra'
#require 'sinatra/reloader'
require 'sqlite3'
require 'twitter'
require './twitter.rb'
require 'geocoder'

set :bind, '0.0.0.0' # needed if you're running from Codio

include ERB::Util

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

before do
    @db = SQLite3::Database.open './database.db'
end

enable :sessions
set :session_secret, 'super secret'

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
    erb :admin
end

post '/admin' do
  # puts "printed to the terminal" 
   @submitted = true
    stm = @db.prepare "SELECT email_address FROM Admins WHERE email_address LIKE '%#{params[:mail]}%'"
    rs = stm.execute
    
    password = @db.execute "SELECT password FROM Admins WHERE email_address LIKE '%#{params[:mail]}%' AND password LIKE '%#{params[:psw]}%'"
    @passwordVarToUseInERB = password
    @password = password.join "\s"
    
    if params[:psw] == @password
        session[:logged_in] = true
        session[:login_time] = Time.now
        redirect '/adminhomepage'
    end
    
    @error = "Password incorrect"
    erb :admin
end

get '/logout' do
    session.clear
    erb :logout 
end

get '/customer' do
    @submitted = false
    erb :customer
end

post '/customer' do
    @submitted = true
    stm = @db.prepare "SELECT twitterHandle FROM UserInfo WHERE twitterHandle LIKE '%#{params[:username]}%'"
    rs = stm.execute
    
    password = @db.execute "SELECT password FROM UserInfo WHERE twitterHandle LIKE '%#{params[:username]}%' AND password LIKE '%#{params[:psw]}%'"
    @customerPasswordForERB = password
    @password = password.join "\s"
    $userID = @db.execute "SELECT user_id FROM UserInfo WHERE twitterHandle LIKE '%#{params[:username]}%' AND password LIKE '%#{params[:psw]}%'" 
    
    if params[:psw] == @password
        session[:logged_in] = true
        session[:login_time] = Time.now
        redirect '/customerhomepage'
    end
    
    @error = "Password incorrect"
    erb :customer
end

post '/twitterReply' do
    tHandle = params[:Handle].strip
    text = params[:text].strip
    makeTweet($client,tHandle,text)
    erb:adminhomepage
end

get '/adminhomepage' do
    
    checkIfNewTweets(client)
    @submitted = false;
    results = client.search('@ise19team09')
    #used dollar sign to make this a global variable:
    #dolar sign also used in adminhomepage.erb to access this variable in adminhomepage.erb
    $tweets = results.take(20)

  
    $results = @db.execute('SELECT user_id, pick_up, destination, time, tier_id  FROM CurrentOrders')
    redirect '/admin' unless session[:logged_in]
    
    erb :adminhomepage
end

post '/adminhomepage' do
    @submitted = true
    @tname = params[:tname].strip
    @pickuplocation = params[:pickuplocation].strip
    @destination = params[:destination].strip
    @datetime = params[:datetime].strip
    @tier_id = params[:tier_id].strip
    
    
    #geocoding the pickup and dropoff locations
    geocodingresults = Geocoder.search(@pickuplocation)
    @pickupGeocode = geocodingresults.first.coordinates.to_s
    puts "#{@pickupGeocode}"
    geocodingresults = Geocoder.search(@destination)
    @destinationGeocode = geocodingresults.first.coordinates.to_s
    puts "#{@destinationGeocode}"
  
    #user_id = @db.execute('SELECT user_id FROM UserInfo WHERE twitterHandle = ?', [@tname])
    user_id=@db.get_first_value 'SELECT MAX(user_id)+1 FROM CurrentOrders'
    
    @db.execute('INSERT INTO CurrentOrders VALUES (?,?,?,?,?,?)',[user_id,@pickupGeocode,@destinationGeocode,@datetime.to_s,@tier_id, 1])
    $results = @db.execute('SELECT user_id, pick_up, destination, time, tier_id
                          FROM CurrentOrders')
    erb :adminhomepage
end

get '/customerhomepage' do
    redirect '/customer' unless session[:logged_in]
    erb :customerhomepage
end

get '/signup' do
    @submitted = false
    erb :signup
end

post '/signup' do
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

#get '/viewincomingtweets' do
#    results = client.search('@ise19team09')
#    @tweets = results.take(20)
#    erb :viewincomingtweets
#end


get '/orderHistory' do    
    @results = @db.execute('SELECT order_id, user_id, pickup, destination, time, tier_id, discount
                            FROM OrderHistory WHERE user_id = ? ' ,[$userID])
    
    erb :orderHistory
end

get '/viewcustomersdetail' do
    @results = @db.execute('SELECT user_id, firstName, lastName, twitterHandle, emailAddress
                            FROM UserInfo ')
    erb :viewcustomersdetail
end    
    
get '/updatecustomerdetails' do    
    $results = @db.execute('SELECT firstName, lastName, twitterHandle, emailAddress
                            FROM UserInfo WHERE user_id = ?', [$userID] )
    @submitted = false
    erb :updatecustomerdetails
end


post '/updatecustomerdetails' do
    user_id =  @db.execute('SELECT user_id FROM UserInfo WHERE user_id = ?', [$userID])
    @submitted = true
    @fname = params[:fname].strip
    @lname = params[:lname].strip
    @tname = params[:tname].strip
    @mail = params[:mail].strip
    @oldpsw = params[:oldpsw].strip
    @newpsw = params[:newpsw].strip
    @checknewpsw = params[:checknewpsw].strip

 
    if @fname != ""  && @fname != (@db.execute('SELECT firstName FROM UserInfo WHERE user_id = ?', [user_id])).join
        @db.execute('UPDATE UserInfo SET firstName = ? WHERE user_id = ?',[@fname,user_id])
    end
    
    if @lname != "" && @lname != (@db.execute('SELECT lastName FROM UserInfo WHERE user_id = ?', [user_id])).join
        @db.execute('UPDATE UserInfo SET lastName = ? WHERE user_id = ?',[@lname,user_id])
    end
    
    if @tname != "" &&  @tname != (@db.execute('SELECT twitterHandle FROM UserInfo WHERE user_id = ?', [user_id])).join
        @db.execute('UPDATE UserInfo SET twitterHandle = ? WHERE user_id = ?',[@tname,user_id])
    end
    
    if @mail != "" && @mail != (@db.execute('SELECT emailAddress FROM UserInfo WHERE user_id = ?', [user_id])).join
        @db.execute('UPDATE UserInfo SET emailAddress = ? WHERE user_id = ?',[@mail,user_id])
    end

    datapassword = (@db.execute('SELECT password FROM UserInfo WHERE user_id = ?', [user_id])).join
    
    @psw_ok = @oldpsw == datapassword && @newpsw == @checknewpsw
    if  @psw_ok
        @db.execute('UPDATE UserInfo SET password = ? WHERE user_id = ?',[@newpsw,user_id])
    end 
      $results = @db.execute('SELECT firstName, lastName, twitterHandle, emailAddress
                            FROM UserInfo WHERE user_id = ?', [$userID] )
    
        erb :updatecustomerdetails
end

get '/updatetiers' do
    @submitted = false
    erb :updatetiers
end

post '/updatetiers' do
    @submitted = true
    @tier1 = params[:standard]
    @tier2 = params[:extra]
    @tier3 = params[:luxury]

    if @tier1.nil? 
        @db.execute('DELETE FROM CarTiers WHERE car_tier = ?', ['Standard'])
    end
     if @tier2.nil? 
        @db.execute('DELETE FROM CarTiers WHERE car_tier = ?', ['Extra'])
    end
     if @tier3.nil? 
        @db.execute('DELETE FROM CarTiers WHERE car_tier = ?', ['Luxury'])
    end
    erb :updatetiers
end