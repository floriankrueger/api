
Feature: Login

  Users can login to cocoaconferences.org via their twitter accounts.

  @current_wip
  Scenario: Responding to a Twitter PIN Challenge
    Given The user isn't authenticated
    And The OAuth Client is fake
    And The OAuth Client will return a valid User Response
    And The Redis Store is fake
    And The user has already logged in before
    And The Session Master Key is "*ky7o799n7(F62+gXVm+H#Z}6w*b#cKVBJk4Z6B}v[xYRCcMiM"
    And There is a pending Twitter PIN Challenge
    When The user sends a POST to the given challenge url with a PIN of abc123
    Then The Fake OAuth Client should have been called with the a PIN of abc123
    And No new user account should have been created
    And The user account should contain all information from the response
    And The HTTP Status Code should be 200
    And The Location Header should be empty
    And There is a _links Hash with 1 elements
    And There is a link to the user
    And There is an session_token
    And There is an session_secret
    And The access_token has been stored
