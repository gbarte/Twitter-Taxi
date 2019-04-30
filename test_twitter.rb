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

db.execute('DELETE FROM Tweets')
y = tweets.take(1)
x = y[0]
userId = db.execute('SELECT user_id FROM UserInfo WHERE twitterHandle = ?', [x.user.screen_name])
db.execute('INSERT INTO Tweets VALUES (?, ?, ?, ?)',[x.id, userId, x.text, x.created_at.to_s])
x = db.execute('SELECT * FROM Tweets')
x.each do |y|
    puts y[0]
    puts y[1]
end
