
Feature: Discover Conferences

  Every user, regardless whether she is authenticated or not, can discover Conferences using the
  cocoaconferences API.

  Scenario: Generally fetching conferences
    Given The user isn't authenticated
    And There are 2 events of the same conference in the database
    When The user sends a GET to /conferences
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /conferences
    And There is an _embedded Hash with 1 element
    And There is an cc:conference List in the _embedded Hash
    And There is are 1 elements in the cc:conference list
    And Every item in the list is a valid conference

  Scenario: Fetching Conferences
    Given The user isn't authenticated
    And The NSScotland 2014 event is in the database
    And The NSScotland 2015 event is in the database
    And The NSSpain 2014 event is in the database
    And The NSSpain 2015 event is in the database
    And The iOS Dev UK 2014 event is in the database
    And The iOS Dev UK 2015 event is in the database
    And The iOSCon 2014 event is in the database
    And The iOSCon 2015 event is in the database
    When The user sends a GET to /conferences
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /conferences
    And There is an _embedded Hash with 1 element
    And There is an cc:conference List in the _embedded Hash
    And There is are 4 elements in the cc:conference list
    And The first conference should be iOSCon
    And The second conference should be iOS Dev UK
    And The third conference should be NSSpain
    And The fourth conference should be NSScotland

  Scenario: Fetch a specific conference
    Given The user isn't authenticated
    And The NSScotland 2015 event is in the database
    And The NSSpain 2015 event is in the database
    When The user fetches NSSpain conference by ID
    Then The HTTP Status Code should be 200
    And The delivered conference should be the NSSpain

  Scenario: Fetch a specific conference that doesn't exist
    Given The user isn't authenticated
    And There are no events in the database
    When The user fetches a conference with some ID
    Then The HTTP Status Code should be 404

  @wip
  Scenario: Fetch events for a conference
    Given The user isn't authenticated
    And The NSSpain 2015 event is in the database
    And The NSSpain 2014 event is in the database
    When The user fetches the events for the NSSpain conference
    Then The HTTP Status Code should be 200
    And There is a _links Hash with 1 element
    And There is a link to self with an href of /conferences/1/events
    And There is an _embedded Hash with 1 element
    And There is an cc:event List in the _embedded Hash
    And There is are 2 elements in the cc:event list
    And Every item in the list is a valid event
    And The first event should be NSSpain 2015
    And The second event should be NSSpain 2014

  @wip
  Scenario: Fetch events for a conference that doesn't exist
    Given The user isn't authenticated
    And There are no events in the database
    When The user fetches the events for some conference
    Then The HTTP Status Code should be 404
