require 'minitest/autorun'
require 'sqlite3'
#require 'sinatra'
#require 'twitter'
require_relative 'string_comparison.rb'

#before do
#    @db = SQLite3::Database.open './database.db'
#end

class TestStringComparison < Minitest::Test
    
    #tests go here
    def test_admin_username_input
        @db = SQLite3::Database.open './database.db'
        admin_email_address = @db.execute "SELECT email_address FROM Admins WHERE email_address LIKE '%admintest1%'"
        assert_equal "admin emails are the same", admin_username_comparison("admintest1@gmail.com",admin_email_address)
    end
    
end
