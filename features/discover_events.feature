
Feature: Discover Events

  Every user, regardless whether she is authenticated or not, can discover Events using the
  cocoaconferences API.

  Scenario: Discover the possibilities
    Given The user isn't authenticated
    When The user fetches root
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 6 elements
    And There is a link to the events with an href of /events
    And There is a link to the conferences with an href of /conferences
    And There is a link to the cities with an href of /cities
    And There is a link to the countries with an href of /countries
    And There is a link to the continents with an href of /continents
    And There is a link to the authentication with an href of /auth

  Scenario: Generally fetching events
    Given The user isn't authenticated
    And There are 2 events in the database
    When The user sends a GET to /events
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /events
    And There is an _embedded Hash with 1 element
    And There is an cc:event List in the _embedded Hash
    And There is are 2 elements in the cc:event list
    And Every item in the list is a valid event

  Scenario: Fetching events
    Given The user isn't authenticated
    And The NSScotland 2015 event is in the database
    And The NSSpain 2015 event is in the database
    And The iOS Dev UK 2015 event is in the database
    And The iOSCon 2015 event is in the database
    When The user sends a GET to /events
    Then The HTTP Status Code should be 200
    And There is an cc:event List in the _embedded Hash
    And There is are 4 elements in the cc:event list
    And The first event should be iOSCon 2015
    And The second event should be iOS Dev UK 2015
    And The third event should be NSSpain 2015
    And The fourth event should be NSScotland 2015

  Scenario: Fetch a specific event
    Given The user isn't authenticated
    And The NSScotland 2015 event is in the database
    And The NSSpain 2015 event is in the database
    When The user fetches NSSpain 2015 event by ID
    Then The HTTP Status Code should be 200
    And The delivered event should be the NSSpain 2015

  @wip
  Scenario: Fetch a specific event that doesn't exist
    Given The user isn't authenticated
    And There are no events in the database
    When The user fetches an event with some ID
    Then The HTTP Status Code should be 404
