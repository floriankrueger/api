
Feature: Create Events

  Every authenticated user can create new events.

  Scenario: Try to create an event without authentication
    Given We have everything in place for an authenticated user
    And The user isn't authenticated
    And There are no events in the database
    And There are no countries in the database
    And There are no cities in the database
    And There are no conferences in the database
    And The continents are setup
    When The user sends a POST to the events collection with a valid body
    Then The HTTP Status Code should be 401
    And The Location Header should be empty
    And There should be 0 countries in the database
    And There should be 0 cities in the database
    And There should be 0 events in the database
    And There should be 0 conferences in the database

  Scenario: Creating a new event without continent information
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection without continent information
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Provide continent information!"
    And There should be 0 events in the database

  Scenario: Creating a new event with a wrong continent code
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection with an invalid continent code "xx"
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should begin with "Invalid continent code 'xx'."
    And There should be 0 events in the database

  Scenario: Creating a new event without country information
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection without country information
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Provide country information!"
    And There should be 0 events in the database

  Scenario: Creating a new event with a new country without a name
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection with a new country without a name
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Unknown country. Please provide the countries’ name in english."
    And There should be 0 events in the database

  Scenario: Creating a new event without city information
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection without city information
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Provide city information!"
    And There should be 0 events in the database

  Scenario: Creating a new event with a new city without a name
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection with a new city without a name
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Unknown city. Please provide the cities’ name in english."
    And There should be 0 events in the database

  Scenario: Creating a new event without conference information
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection without conference information
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Provide conference information!"
    And There should be 0 events in the database

  Scenario: Creating a new event with a new conference without a name
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection with a new conference without a name
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Invalid conference. Please provide the conferences’ name."
    And There should be 0 events in the database

  Scenario: Creating a new event without a start date
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection without a start date
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Invalid event information!"
    And There should be 0 events in the database

  Scenario: Creating a new event without an end date
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection without an end date
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Invalid event information!"
    And There should be 0 events in the database

  Scenario: Creating a new event without website information
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And The continents are setup
    When The user sends a POST to the events collection without website information
    Then The HTTP Status Code should be 400
    And There should be an Error
    And The Error message should say "Invalid event information!"
    And There should be 0 events in the database

  @wip
  Scenario: Creating a new event with a new country, new city and new conference
    Given We have everything in place for an authenticated user
    And The user is authenticated
    And There are no events in the database
    And There are no countries in the database
    And There are no cities in the database
    And There are no conferences in the database
    And The continents are setup
    When The user sends a POST to the events collection with a valid body
    Then The HTTP Status Code should be 201
    And The Location Header should point to the Event
    And There should be 1 country in the database
    And There should be 1 city in the database
    And There should be 1 event in the database
    And There should be 1 conference in the database
