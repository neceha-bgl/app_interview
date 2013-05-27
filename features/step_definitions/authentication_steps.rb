Given /^a user visits the signin page$/ do
  visit signin_path
end

When /^he submits invalid signin information$/ do
  click_button "Sign in"
end

Then /^he should see an error message$/ do
  page.should have_selector('div.alert.alert-error')
end

Given /^the user has an account$/ do
  @user=User.create(name: "Example User", email:"user@example.com", 
  password:"foobar", password_confirmation:"foobar")
end

When /^the user submits valid signin information$/ do
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "Sign in"
end

Then /^he should see his profile page$/ do
  page.should have_selector('title', text: @user.name)
end

Then /^he should see a signout link$/ do
  page.should have_link('Sign out', href: signout_path)
end

Given /^a recorded application$/ do
  admin = User.create(name: "Admin", email:"admin@example.com", password:"admin", password_confirmation:"admin")
  admin.toggle!(:admin)

  # sing in as admin
  visit signin_path
  fill_in "Email", with: admin.email
  fill_in "Password", with: admin.password
  click_button "Sign in"

  visit new_oauth_application_path
  fill_in "application_name", with: "doorkeeper_client"
  fill_in "application_redirect_uri", with: "urn:ietf:wg:oauth:2.0:oob" 
  click_button "Submit"

  #sign out
  visit root_url
  click_link "Sign out"

end

When /^the user sign in with doorkeeper$/ do

  @application = Doorkeeper::Application.last
  client = OAuth2::Client.new(@application.uid, @application.secret, site: "http://localhost:3000/") do |b|
    b.request :url_encoded
    b.adapter :rack, Rails.application
  end

  path = client.auth_code.authorize_url(redirect_uri: @application.redirect_uri)
 
  visit path
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "Sign in"

  click_button "Authorize"
  
  authorization_code =  page.find_by_id("authorization_code").text 
  @access = client.auth_code.get_token(authorization_code, redirect_uri: @application.redirect_uri)
end

When /^request the user api$/ do
  @result = @access.get("/api/user").parsed
end

Then /^he should see his data with json format$/ do
  @result.should  eq(@user.to_api)
end
