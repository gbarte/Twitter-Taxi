require 'sqlite3'
require 'twitter'
config = {
:consumer_key => 'lqCpGOUMYGXaSLMAYUyqH9MhX',
:consumer_secret => 'aMUTzyD8UlzcHqyWTtgrgNA6L7LKy9tL6WP7jCRCrVVxYzJa1D',
:access_token => '1092447528761610240-sKtozZ8IDihSED4UuFK2fk39bWNCa7',
:access_token_secret => 'CbNNmZHlIZJSttTk3OlAhZ4vdfE9BJtv0iBDYGy8YHar7'
}
db = SQLite3::Database.open('database.db')
client = Twitter::REST::Client.new(config)

tweets = client.search('@ise19team09')

newestOrder = db.execute('SELECT tweet_id FROM Tweets LIMIT 1')
newestOrder = newestOrder[0][0].to_s

def checkIfNewTweets(newestOrder, tweets)
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
   return newestTweet.id, newTweets

end

newestOrder, newTweets = checkIfNewTweets(newestOrder, tweets)
newTweets.each do |x|
    #Get user_id from UserInfo using twitter handle
    userId = db.execute('SELECT user_id FROM UserInfo WHERE twitterHandle = ?', [x.user.screen_name])
    #Insert new tweet with user_id
    db.execute(
        'INSERT INTO Tweets VALUES (?, ?, ?, ?)',
        [x.id, userId, x.text, x.created_at.to_s])
end