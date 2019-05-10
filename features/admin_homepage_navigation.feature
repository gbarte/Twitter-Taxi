Feature: admin homepage navigation

    Scenario: click on Logout on navigation bar
        Given I am on admin homepage
        When I follow "Logout" within ".header"
        Then I should be on logout page
        
    Scenario: click on Admin account on navigation bar
        Given I am on admin homepage
        When I follow "Admin homepage" within ".header"
        Then I should be on admin homepage
        
    Scenario: click on Admin account main content
        Given I am on admin homepage
        When I follow "Add New Admin" within ".header"
        Then I should be on add new admin
        
    Scenario: click on Admin account main content
        Given I am on admin homepage
        When I follow "View Customer Details" within ".header"
        Then I should be on customer details page
        
    Scenario: click on Admin account main content
        Given I am on admin homepage
        When I follow "Update Available Tiers" within ".header"
        Then I should be on update tiers page
        
