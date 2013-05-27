Feature: API user 
	
	Scenario: Retrive user profile info 
	Given a recorded application
  When the user has an account
		And the user sign in with doorkeeper
		And request the user api
	Then he should see his data with json format 
