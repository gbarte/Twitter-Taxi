Feature: Signup
    Scenario: Correct Sign Up
        Given I am on customer signup page
        When I fill in "fname" with "firstName"
        When I fill in "lname" with "lastName"
        When I fill in "tname" with "TwitterID"
        When I fill in "psw" with "sercet"
        When I fill in "mail" with "test1234@aol.com"
        When I press "Sign Up" within "input .submit"
        Then I should see "Thanks"
        
    Scenario: Incorrect email Sign Up
        Given I am on customer signup page
        When I fill in "fname" with "firstName"
        When I fill in "lname" with "lastName"
        When I fill in "tname" with "TwitterID"
        When I fill in "psw" with "sercet"
        When I fill in "mail" with "incorrect"
        When I press "Sign Up" within ".main"
        Then I should not see "Thanks"
        
    Scenario: No First Name entered Sign Up
        Given I am on customer signup page
        When I fill in "lname" with "lastName"
        When I fill in "tname" with "TwitterID"
        When I fill in "psw" with "sercet"
        When I fill in "mail" with "incorrect"
        When I press "Sign Up" within ".submit"
        Then I should see "Please enter your first name"
        
    Scenario: No Last Name entered Sign Up
        Given I am on customer signup page
        When I fill in "fname" with "firstName"
        When I fill in "tname" with "TwitterID"
        When I fill in "psw" with "sercet"
        When I fill in "mail" with "incorrect"
        When I press "Sign Up" within ".submit"
        Then I should see "Please enter your last name"
  
    Scenario: No TwitterID entered Sign Up
        Given I am on customer signup page
        When I fill in "fname" with "firstName"
        When I fill in "lname" with "lastName"
        When I fill in "psw" with "sercet"
        When I fill in "mail" with "incorrect"
        When I press "Sign Up" within ".submit"
        Then I should see "Please enter your twitter handle"
        
    Scenario: No Password entered Sign Up
        Given I am on customer signup page
        When I fill in "fname" with "firstName"
        When I fill in "lname" with "lastName"
        When I fill in "tname" with "TwitterID"
        When I fill in "mail" with "incorrect"
        When I press "Sign Up" within ".submit"
        Then I should see "Please enter your password"
        