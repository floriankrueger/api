
Feature: Register New User

  Users can register themselves for cocoaconferences.org via their twitter accounts.

  Scenario: Attempt to sign in via Twitter using no method
    Given The user isn't authenticated
    When The user sends a post to /users with an unsupported method
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say that a valid authentication method is needed
    And The Info object should contain a list of supported methods

  Scenario: Attempt to sign in via Twitter using an unknown method
    Given The user isn't authenticated
    When The user sends a post to /users with an unsupported method
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say that a valid authentication method is needed
    And The Info object should contain a list of supported methods

#  Scenario: Sign in via Twitter using the PIN method
#    Given The user isn't authenticated
#    When A user sends a post to /users
#    Then The HTTP Status Code should be 200
#    And There is a _links Hash with 2 elements
#    And There is a link to the twitter page
#    And There is a link to the challenge
