
Feature: Create Events

  Every authenticated user can create new events.

  Scenario: Creating a new event
    Given There are no events in the database
    And A new event is created
    Then There should be one event in the database
