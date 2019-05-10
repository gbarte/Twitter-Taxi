Feature: homepage navigation

    Scenario: click on Customer account on navigation bar
        Given I am on homepage
        When I follow "Customer account" within ".header"
        Then I should be on customer login page
        
    Scenario: click on Admin account on navigation bar
        Given I am on homepage
        When I follow "Admin account" within ".header"
        Then I should be on admin login page
        
    Scenario: click on Customer account within main content
        Given I am on homepage
        When I follow "Customer account" within ".top"
        Then I should be on customer login page
        
    Scenario: click on Admin account main content
        Given I am on homepage
        When I follow "Admin account" within ".top"
        Then I should be on admin login page
        
    Scenario: click on Sign up now main content
        Given I am on homepage
        When I follow "Sign up now->" within "ul li span"
        Then I should be on customer signup page