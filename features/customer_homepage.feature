Feature: customer homepage

    Scenario: click on Logout on navigation bar
        Given I am on customer homepage
        When I follow "Logout" within ".header"
        Then I should be on logout page
            
    Scenario: click on Update Personal Details on navigation bar
        Given I am on customer homepage
        When I follow "Update Personal Details" within ".header"
        Then I should be on update customer details page
        
    Scenario: click on Order History on navigation bar
        Given I am on customer homepage
        When I follow "Order History" within ".header"
        Then I should be on customer order history page