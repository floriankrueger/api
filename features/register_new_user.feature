
Feature: Register New User

  Users can register themselves for cocoaconferences.org via their twitter accounts.

  Scenario: Attempt to sign in via Twitter using no method
    Given The user isn't authenticated
    When The user sends a post to /auth/challenges without a method
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Please supply a valid authentication method. Supported methods are: pin"

  Scenario: Attempt to sign in via Twitter using an unknown method
    Given The user isn't authenticated
    When The user sends a post to /auth/challenges with an unsupported method
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Please supply a valid authentication method. Supported methods are: pin"

  Scenario: Sign in via Twitter using the PIN method
    Given The user isn't authenticated
    And The OAuth Client is fake
    And The Redis Store is fake
    When The user sends a post to /auth/challenges using the method pin
    Then The Fake OAuth Client should have been called with the PIN method
    And A fake PIN Challenge should have been created
    And The HTTP Status Code should be 201
    And The Location Header should point to the Challenge
    And There is a _links Hash with 1 elements
    And There is a self link to the challenge
    And There is a link to the twitter authentication page

  Scenario: Responding to an invalid or expired Twitter Challenge
    Given The user isn't authenticated
    And The user has never logged in before
    And The OAuth Client is fake
    And The Redis Store is fake
    And There is no pending Twitter PIN Challenge for the key abcdef
    When The user sends a POST to the challenge abcdef with some auth data
    Then The HTTP Status Code should be 404
    And There should be an Error
    And The Error message should say "Unknown Challenge ID. The Challenge might have expired."

  Scenario: Responding to a Twitter PIN Challenge without auth data
    Given The user isn't authenticated
    And The user has never logged in before
    And The OAuth Client is fake
    And The Redis Store is fake
    And There is a pending Twitter PIN Challenge
    When The user sends a POST to the given challenge url with no auth data
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Insufficient Data. To fulfill a PIN Challenge you need to provide a {'pin':'<some_pin>'}"

  Scenario: Responding to a Twitter PIN Challenge
    Given The user isn't authenticated
    And The user has never logged in before
    And The OAuth Client is fake
    And The Redis Store is fake
    And The Session Master Key is "*ky7o799n7(F62+gXVm+H#Z}6w*b#cKVBJk4Z6B}v[xYRCcMiM"
    And There is a pending Twitter PIN Challenge
    When The user sends a POST to the given challenge url with a PIN of abc123
    Then The Fake OAuth Client should have been called with the a PIN of abc123
    #And A user account should have been created
    And The HTTP Status Code should be 200
    #And There is a _links Hash with 1 elements
    #And There is a link to the user
    And There is an session_token
    And There is an session_secret
    And The access_token has been stored
