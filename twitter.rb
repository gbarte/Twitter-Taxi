require 'twitter'
config = {
:consumer_key => 'lqCpGOUMYGXaSLMAYUyqH9MhX',
:consumer_secret => 'aMUTzyD8UlzcHqyWTtgrgNA6L7LKy9tL6WP7jCRCrVVxYzJa1D',
:access_token => '1092447528761610240-sKtozZ8IDihSED4UuFK2fk39bWNCa7',
:access_token_secret => 'CbNNmZHlIZJSttTk3OlAhZ4vdfE9BJtv0iBDYGy8YHar7'
}
client = Twitter::REST::Client.new(config)

tweets = client.user_timeline('ise19team09')

newestOrder = tweets.take(1)

def checkIfNewTweets(newestOrder, tweets)
    i = 1
    newTweets = []
    newestTweet = tweets.take(1)
    #Checks if the newest tweet is the newest order
    while (newestTweet != newestOrder)
        #if not then there is a new order
        #Gets next batch of new tweets
        mostRecent = tweets.take(i)
        #Checks newest out of grabbed tweets
        if mostRecent[i-1] != newestOrder 
            #add to new orders
            newTweets << mostRecent[i-1]
            i += 1
        elsif mostRecent[i-1] == newestOrder
            #is equal to the newest order so stop
            break;
        end
    end  
    return newestTweet, newTweets
end

for i in 0..2 do
    newestOrder, newTweets = checkIfNewTweets(newestOrder, tweets)
    sleep 60
end
