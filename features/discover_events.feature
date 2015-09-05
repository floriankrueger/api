
Feature: Discover Events

  Every user, regardless whether she is authenticated or not, can discover Events using the
  cocoaconferences API.

  Scenario: Discover the possibilities
    Given The user isn't authenticated
    When He fetches the root via GET
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 5 elements
    And There is a link to the events
    And There is a link to the conferences
    And There is a link to the cities
    And There is a link to the countries
    And There is a link to the continents
