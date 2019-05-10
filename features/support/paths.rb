module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /home\s?page/
        '/index'
    when /customer signup page/
        '/signup'
    when /customer login page/
        '/customer'
    when /admin login page/
        '/admin'
    when /admin homepage/
        '/adminhomepage'
    when /add new admin page/
        '/addnewadmin'
    when /customer details page/
        '/viewcustomersdetail'
    when /add new admin page/
        '/addnewadmin'
    when /customer homepage/
        '/customerhomepage'
    when /customer order history page/
        '/orderHistory'
    when /update customer details page/
        '/updatecustomerdetails'
    when /update tiers page/ 
        '/updatetiers'
    when /logout page/
        '/logout'
    
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"

    end
  end
end

World(NavigationHelpers)
