require 'sqlite3'
require 'twitter'
#config = {
#:consumer_key => 'lqCpGOUMYGXaSLMAYUyqH9MhX',
#:consumer_secret => 'aMUTzyD8UlzcHqyWTtgrgNA6L7LKy9tL6WP7jCRCrVVxYzJa1D',
#:access_token => '1092447528761610240-sKtozZ8IDihSED4UuFK2fk39bWNCa7',
#:access_token_secret => 'CbNNmZHlIZJSttTk3OlAhZ4vdfE9BJtv0iBDYGy8YHar7'
#}

#client = Twitter::REST::Client.new(config)

#tweets = client.search('@ise19team09')

def checkIfNewTweets(client)
   $db = SQLite3::Database.open('database.db')
   newestOrder = $db.execute('SELECT * FROM Tweets ORDER BY tweet_id DESC LIMIT 1')
   tweets = client.search('@ise19team09')
   if newestOrder == []
       newestOrder = tweets.take(1)[0].id
   end
   newestOrder = newestOrder[0][0].to_s
   i = 1
   newTweets = []
   newestTweet = tweets.take(1)[0]
   #puts newestTweet.text
   #puts newestOrder
   #Checks if the newest tweet is the newest order
   while (true)
       #if not then there is a new order
       #Gets next batch of new tweets
       mostRecent = tweets.take(i)
       #Checks newest out of grabbed tweets
       if mostRecent[i-1] == nil
           break;
       elsif (mostRecent[i-1].id).to_s != newestOrder
           #add to new orders
           puts i
           newTweets << mostRecent[i-1]
           i += 1
       elsif (mostRecent[i-1].id).to_s == newestOrder
           #is equal to the newest order so stop
           break;
       else
           puts "test"
       end
   end
   updateDatabase(newTweets)
end

def updateDatabase(newTweets) 
    newTweets.each do |x|
        #Get user_id from UserInfo using twitter handle
        userId = $db.execute('SELECT user_id FROM UserInfo WHERE twitterHandle = ?', [x.user.screen_name])
        #Insert new tweet with user_id
        $db.execute(
            'INSERT INTO Tweets VALUES (?, ?, ?, ?)',
            [x.id, userId, x.text, x.created_at.to_s])
    end
end

def makeTweet(client, tHandle, text)
    client.update(('@'+tHandle+' '+text))
    tweets = client.user_timeline('ise19team09')
    tweet = tweets.take(1)[0]
    $db.execute('INSERT INTO Tweets VALUES (?, ?, ?, ?)', [tweet.id, 1, text, tweet.created_at.to_s])
end