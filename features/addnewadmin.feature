Feature: Add new Admin

    Scenario: Correct input entered
        Given I am on add new admin page
        When I fill in "email" with "testnewadmin@gmail.com"
        When I fill in "psw" with "passwordtest"
        When I press "Sign Up" within ".main"
        Then I should not see "Please include an '@'"
        
    Scenario: No password entered
        Given I am on add new admin page
        When I fill in "email" with "testnewadmin@gmail.com"
        When I fill in "psw" with ""
        When I press "Sign Up" within ".main"
        Then I should see "Please enter a password"
        
    Scenario: Invalid email entered
        Given I am on add new admin page
        When I fill in "email" with "testnewadmin.com"
        When I fill in "psw" with "bfuiafbqa"
        When I press "Sign Up" within ".main"
        Then I should see "Please include an '@'"
    
    Scenario: No email entered
        Given I am on add new admin page
        When I fill in "email" with ""
        When I fill in "psw" with "bfuiafbqa"
        When I press "Sign Up" within ".main"
        Then I should see "Please include an '@'"