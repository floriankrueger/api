
@wip
Feature: Discover Cities

  Every user, regardless whether she is authenticated or not, can discover Cities using the
  cocoaconferences API.

  Scenario: Generally fetch cities
    Given The user isn't authenticated
    And The NSScotland 2015 event is in the database
    And The NSSpain 2015 event is in the database
    And The iOS Dev UK 2015 event is in the database
    And The iOSCon 2015 event is in the database
    And The WWDC 2015 event is in the database
    When The user sends a GET to /cities
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /cities
    And There is an _embedded Hash with 1 element
    And There is an cc:city List in the _embedded Hash
    And There is are 5 elements in the cc:city list
    And Every item in the list is a valid city
    And The first city should be Aberystwyth
    And The second city should be Edinburgh
    And The third city should be Logroño
    And The fourth city should be London
    And The fifth city should be San Fransisco

  Scenario: Fetch a specific city
    Given The user isn't authenticated
    And The NSSpain 2015 event is in the database
    And The WWDC 2015 event is in the database
    When The user sends a GET to /cities/eslgr
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 4 elements
    And There is a link to self with an href of /cities/eslgr
    And There is a link to cc:country with an href of /countries/es
    And There is a link to cc:continent with an href of /continents/eu
    And There is a link to cc:event with an href of /cities/eslgr/events
    And There is a field "code" with a value of "eslgr"
    And There is a field "name" with a value of "Logroño"

  Scenario: Fetch a city that doesn't exist
    Given The user isn't authenticated
    When The user sends a GET to /cities/abcde
    Then The HTTP Status Code should be 404

  Scenario: Fetch events for a specific city
    Given The user isn't authenticated
    And The NSSpain 2015 event is in the database
    And The WWDC 2015 event is in the database
    When The user sends a GET to /cities/eslgr/events
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /cities/eslgr/events
    And There is an _embedded Hash with 1 element
    And There is an cc:event List in the _embedded Hash
    And There is are 1 element in the cc:event list
    And Every item in the list is a valid event
    And The first event should be NSSpain 2015

  Scenario: Fetch events for a city that doesn't exist
    Given The user isn't authenticated
    When The user sends a GET to /cities/abcde/events
    Then The HTTP Status Code should be 404
