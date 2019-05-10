Feature: customer login

    
    Scenario: Correct password and username entered
        Given I am on customer login page
        When I fill in "username" with "ise19team09" within ".main"
        When I fill in "psw" with "111" within ".main"
        When I press "Login" within ".main"
        Then I should be on customer homepage
        
    Scenario: Incorrect username entered
        Given I am on customer login page
        When I fill in "username" with "" within ".main"
        When I fill in "psw" with "111" within ".main"
        When I press "Login" within ".main"
        Then I should see "Your Twitter handle or password was incorrect"
        
    Scenario: Incorrect password entered
        Given I am on customer login page
        When I fill in "username" with "ise19team09" within ".main"
        When I fill in "psw" with "" within ".main"
        When I press "Login" within ".main"
        Then I should see "Your Twitter handle or password was incorrect"
    
    Scenario: Incorrect password and username entered
        Given I am on customer login page
        When I fill in "username" with "" within ".main"
        When I fill in "psw" with "" within ".main"
        When I press "Login" within ".main"
        Then I should see "Your Twitter handle or password was incorrect"
    
    