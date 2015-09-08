
Feature: Discover Events

  Every user, regardless whether she is authenticated or not, can discover Events using the
  cocoaconferences API.

  Scenario: Discover the possibilities
    Given The user isn't authenticated
    When He fetches the root via GET
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 6 elements
    And There is a link to the events with an href of /events
    And There is a link to the conferences with an href of /conferences
    And There is a link to the cities with an href of /cities
    And There is a link to the countries with an href of /countries
    And There is a link to the continents with an href of /continents
    And There is a link to the authentication with an href of /auth
