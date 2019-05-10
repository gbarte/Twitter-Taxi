Feature: homepage navigation

    Scenario: click on Admin account
        Given I am on homepage
        When I press "Admin account" within "ul li"
        Then I should be on admin login page
        
    Scenario: click on Sign up now
        Given I am on homepage
        When I press "Sign up now ->" within "@id='#{last2}'"
        Then I should be on customer signup page