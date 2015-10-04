
Feature: Discover Countries

  Every user, regardless whether she is authenticated or not, can discover Countries using the
  cocoaconferences API.

  Scenario: Generally fetch countries
    Given The user isn't authenticated
    And The NSScotland 2015 event is in the database
    And The NSSpain 2015 event is in the database
    And The iOS Dev UK 2015 event is in the database
    And The iOSCon 2015 event is in the database
    And The WWDC 2015 event is in the database
    When The user sends a GET to /countries
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /countries
    And There is an _embedded Hash with 1 element
    And There is an cc:country List in the _embedded Hash
    And There is are 3 elements in the cc:country list
    And Every item in the list is a valid country
    And The first country should be Spain
    And The second country should be the United Kingdom
    And The third country should be the United States

  Scenario: Fetch a specific country that doesn't exist
    Given The user isn't authenticated
    When The user sends a GET to /countries/abc
    Then The HTTP Status Code should be 404

  Scenario: Fetch a specific country
    Given The user isn't authenticated
    And The NSScotland 2015 event is in the database
    And The NSSpain 2015 event is in the database
    When The user sends a GET to /countries/es
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 4 element
    And There is a link to self with an href of /countries/es
    And There is a link to cc:continent with an href of /continents/eu
    And There is a link to cc:city with an href of /countries/es/cities
    And There is a link to cc:event with an href of /countries/es/events
    And There is a field "code" with a value of "es"
    And There is a field "name" with a value of "Spain"

  Scenario: Fetch cities for a country
    Given The user isn't authenticated
    And The NSScotland 2015 event is in the database
    And The iOS Dev UK 2015 event is in the database
    And The iOSCon 2015 event is in the database
    When The user sends a GET to /countries/gb/cities
    Then The HTTP Status Code should be 200
    And There is an _embedded Hash with 1 element
    And There is an cc:city List in the _embedded Hash
    And There is are 3 elements in the cc:city list
    And Every item in the list is a valid city
    And The first city should be Aberystwyth
    And The second city should be Edinburgh
    And The third city should be London

  Scenario: Fetch cities for a country that doesn't exist
    Given The user isn't authenticated
    When The user sends a GET to /countries/abc/cities
    Then The HTTP Status Code should be 404

  Scenario: Fetch events for a country
    Given The user isn't authenticated
    And The NSScotland 2015 event is in the database
    And The iOS Dev UK 2015 event is in the database
    And The WWDC 2015 event is in the database
    When The user sends a GET to /countries/gb/events
    Then The HTTP Status Code should be 200
    And There is an _embedded Hash with 1 element
    And There is an cc:event List in the _embedded Hash
    And There is are 2 elements in the cc:event list
    And Every item in the list is a valid event
    And The first event should be NSScotland 2015
    And The second event should be iOS Dev UK 2015

  Scenario: Fetch events for a country that doesn't exist
    Given The user isn't authenticated
    When The user sends a GET to /countries/abc/events
    Then The HTTP Status Code should be 404
