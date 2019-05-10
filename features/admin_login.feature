Feature: admin login

    
    Scenario: Correct password and username entered
        Given I am on admin login page
        When I fill in "mail" with "admintest1@gmail.com"
        When I fill in "psw" with "passwordtest" 
        When I press "Login" within ".main"
        Then I should be on admin homepage
        
    Scenario: Incorrect email entered
        Given I am on admin login page
        When I fill in "mail" with "admintest1gmail.com" within ".main"
        When I fill in "psw" with "passwordtest" within ".main"
        When I press "Login" within ".main"
        Then I should see "Your email or password was incorrect, please try again."
        
    Scenario: Incorrect password entered
        Given I am on admin login page
        When I fill in "mail" with "admintest1@gmail.com" within ".main"
        When I fill in "psw" with "pasdtest" within ".main"
        When I press "Login" within ".main"
        Then I should see "Your email or password was incorrect, please try again."
    
    Scenario: Incorrect password and username entered
        Given I am on admin login page
        When I fill in "mail" with "" within ".main"
        When I fill in "psw" with "" within ".main"
        When I press "Login" within ".main"
        Then I should see "Your email or password was incorrect, please try again."
    
    