
Feature: Discover Continents

  Every user, regardless whether she is authenticated or not, can discover Continents using the
  cocoaconferences API.

  Scenario: Generally fetching continents
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /continents
    And There is an _embedded Hash with 1 element
    And There is an cc:continent List in the _embedded Hash
    And There is are 7 elements in the cc:continent list
    And Every item in the list is a valid continent

  Scenario: Fetch Africa
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/af
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 3 elements
    And There is a link to self with an href of /continents/af
    And There is a link to cc:country with an href of /continents/af/countries
    And There is a link to cc:event with an href of /continents/af/events
    And There is a field "code" with a value of "af"
    And There is a field "name" with a value of "Africa"

  Scenario: Fetch Antarctica
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/an
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 3 elements
    And There is a link to self with an href of /continents/an
    And There is a link to cc:country with an href of /continents/an/countries
    And There is a link to cc:event with an href of /continents/an/events
    And There is a field "code" with a value of "an"
    And There is a field "name" with a value of "Antarctica"

  Scenario: Fetch Asia
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/as
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 3 elements
    And There is a link to self with an href of /continents/as
    And There is a link to cc:country with an href of /continents/as/countries
    And There is a link to cc:event with an href of /continents/as/events
    And There is a field "code" with a value of "as"
    And There is a field "name" with a value of "Asia"

  Scenario: Fetch Europe
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/eu
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 3 elements
    And There is a link to self with an href of /continents/eu
    And There is a link to cc:country with an href of /continents/eu/countries
    And There is a link to cc:event with an href of /continents/eu/events
    And There is a field "code" with a value of "eu"
    And There is a field "name" with a value of "Europe"

  Scenario: Fetch North America
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/na
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 3 elements
    And There is a link to self with an href of /continents/na
    And There is a link to cc:country with an href of /continents/na/countries
    And There is a link to cc:event with an href of /continents/na/events
    And There is a field "code" with a value of "na"
    And There is a field "name" with a value of "North America"

  Scenario: Fetch Oceania
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/oc
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 3 elements
    And There is a link to self with an href of /continents/oc
    And There is a link to cc:country with an href of /continents/oc/countries
    And There is a link to cc:event with an href of /continents/oc/events
    And There is a field "code" with a value of "oc"
    And There is a field "name" with a value of "Oceania"

  Scenario: Fetch South America
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/sa
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 3 elements
    And There is a link to self with an href of /continents/sa
    And There is a link to cc:country with an href of /continents/sa/countries
    And There is a link to cc:event with an href of /continents/sa/events
    And There is a field "code" with a value of "sa"
    And There is a field "name" with a value of "South America"

  Scenario: Fetch a continent that doesn't exist
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/abc
    Then The HTTP Status Code should be 404

  Scenario: Fetch the countries for a continent
    Given The user isn't authenticated
    And The continents are setup
    And The NSSpain 2015 event is in the database
    And The WWDC 2015 event is in the database
    When The user sends a GET to /continents/eu/countries
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /continents/eu/countries
    And There is an _embedded Hash with 1 element
    And There is an cc:country List in the _embedded Hash
    And There is are 1 element in the cc:country list
    And The first country should be Spain

  Scenario: Fetch the countries for a nonexisting continent
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/abc/countries
    Then The HTTP Status Code should be 404

  Scenario: Fetch the events for a continent
    Given The user isn't authenticated
    And The continents are setup
    And The NSSpain 2015 event is in the database
    And The WWDC 2015 event is in the database
    When The user sends a GET to /continents/eu/events
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /continents/eu/events
    And There is an _embedded Hash with 1 element
    And There is an cc:event List in the _embedded Hash
    And There is are 1 element in the cc:event list
    And The first event should be NSSpain 2015

  Scenario: Fetch the events for a nonexisting continent
    Given The user isn't authenticated
    And The continents are setup
    When The user sends a GET to /continents/abc/events
    Then The HTTP Status Code should be 404
