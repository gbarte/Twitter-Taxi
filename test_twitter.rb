require 'twitter'

config = {
    :consumer_key => 'lqCpGOUMYGXaSLMAYUyqH9MhX',
    :consumer_secret => 'aMUTzyD8UlzcHqyWTtgrgNA6L7LKy9tL6WP7jCRCrVVxYzJa1D',
    :access_token => '1092447528761610240-sKtozZ8IDihSED4UuFK2fk39bWNCa7',
    :access_token_secret => 'CbNNmZHlIZJSttTk3OlAhZ4vdfE9BJtv0iBDYGy8YHar7'
}

client = Twitter::REST::Client.new(config)

client.update('This is Ali sending an automated tweet using Ruby')