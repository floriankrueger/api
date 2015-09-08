
Feature: Register New User

  Users can register themselves for cocoaconferences.org via their twitter accounts.

  Scenario: Attempt to sign in via Twitter using no method
    Given The user isn't authenticated
    When The user sends a post to /auth/challenges without a method
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say that a valid authentication method is needed

  Scenario: Attempt to sign in via Twitter using an unknown method
    Given The user isn't authenticated
    When The user sends a post to /auth/challenges with an unsupported method
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say that a valid authentication method is needed

  Scenario: Sign in via Twitter using the PIN method
    Given The user isn't authenticated
    And The OAuth Client is fake
    And The Redis Store is fake
    When The user sends a post to /auth/challenges using the method pin
    Then The Fake OAuth Client should have been called with the PIN method
    Then A fake Challenge should have been created
    And The HTTP Status Code should be 200
#    And There is a _links Hash with 2 elements
#    And There is a link to the twitter page
#    And There is a link to the challenge
