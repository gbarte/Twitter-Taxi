#compare string that admin would input into the database with the 
#actaul values stored in the database.
#if the username that the admin inputs (remeber this is a parameter
# in this test) is the same as one stored in the database then output true
# Also, test for when the admin inputs the incorrect login details
# - this test should return true if there are no admins in the
# database with the same username.


def admin_username_comparison(str1, str2)
    if str1==str2
        return "admin emails are the same"
    end
    return "admin emails are not the same"
end
