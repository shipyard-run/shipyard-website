Feature: Docker Container
  In order to test Shipyard creates containers correctly
  I should apply a blueprint which defines a simple container setup
  and test the resources are created correctly

Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type      |
    | app                       | container |
  And a HTTP call to "http://app.container.shipyard.run:9090" should result in status 200