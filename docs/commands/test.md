---
id: test
title: Test
---
Run functional tests for the blueprint, this command will start the Shipyard blueprint specified by the location `[blueprint]` and run any functional tests specified in the `test` subdirectory. 

For more information, take a look at the [Testing Tutorial](/docs/tutorials/testing)

## Command Usage
```shell
Usage:
  shipyard test [blueprint]

Flags:
      --force-update         When set to true Shipyard will ignore cached images or files and will download all resources
  -h, --help                 help for test
      --purge                When set to true Shipyard will remove any cached images or blueprints
      --test-folder string   Specify the folder containing the functional tests.
```

## Example test
The following example shows a test which would start a blueprint, and assert that the defined resources are created and running, as well as applications defined by the blueprint are accessible and functioning correctly by checking the HTTP response. For more information on the satements please see the [Testing Statements](#testing-statements) section below.

```javascript
Feature: Docker Container
  In order to test Shipyard creates containers correctly
  I should apply a blueprint which defines a simple container setup
  and test the resources are created correctly

Scenario: Single Container from Local Blueprint
  Given the following environment variables are set
    | key            | value                 |
    | CONSUL_VERSION | 1.8.0                 |
    | ENVOY_VERSION  | 1.14.3                |
  And I have a running blueprint
  Then the following resources should be running
    | name                      | type      |
    | onprem                    | network   |
    | consul                    | container |
    | envoy                     | sidecar   |
    | consul-container-http     | ingress   |
  And a HTTP call to "http://consul.container.shipyard.run:8500/v1/status/leader" should result in status 200
  And a HTTP call to "http://consul-http.ingress.shipyard.run:28500/v1/status/leader" should result in status 200
```

## Running Tests
The following example would test the blueprint in the folder `./examples/container`, functional tests are expressed using the `Gherkin` syntax and stored in the folder `./examples/container/test`.

The `--purge` flag will remove all downloaded images, helm charts, or external blueprints after running the tests. This is to ensure that each scenario has no cached dependencies on the previous test.

```shell
shipyard test --purge ./examples/container 
Feature: Docker Container
  In order to test Shipyard creates containers correctly
  I should apply a blueprint which defines a simple container setup
  and test the resources are created correctly

  Scenario: Single Container from Local Blueprint                                                                   # examples/container/test/container.feature:6
    Given the following environment variables are set                                                               # test.go:309 -> *CucumberRunner
      | key            | value  |
      | CONSUL_VERSION | 1.8.0  |
      | ENVOY_VERSION  | 1.14.3 |
    And I have a running blueprint                                                                                  # test.go:141 -> *CucumberRunner
    Then the following resources should be running                                                                  # test.go:189 -> *CucumberRunner
      | name                  | type      |
      | onprem                | network   |
      | consul                | container |
      | envoy                 | sidecar   |
      | consul-container-http | ingress   |
    And a HTTP call to "http://consul.container.shipyard.run:8500/v1/status/leader" should result in status 200     # test.go:277 -> *CucumberRunner
    And a HTTP call to "http://consul-http.ingress.shipyard.run:28500/v1/status/leader" should result in status 200 # test.go:277 -> *CucumberRunner
```

## Testing Statements
When writing features the following statements can be used.

### I have a running blueprint
The statement `I have a running blueprint` creates the resources in the blueprint.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
```

### The environment variable `"<key>"` has a value `"<value>"`
This statement allows you to set environment variables for your blueprints before executing the tests.

```javascript
Scenario: Single Container from Local Blueprint
  Given the environment variable "CONSUL_VERSION" has a value "1.8.0"
  And I have a running blueprint
```

Environment variables can be interpolated inside of your blueprints and allow you to create dynamic code. For example the following allows you to set the version of a Docker container using an environment variable.

```javascript
container "consul" {
  image   {
    name = "consul:${env("CONSUL_VERSION")}"
  }
}
```

When you run your tests the environment varaible will be set and interpolated before the blueprint is created.

### The following environment varaibles are set
This statement is similar to the previous except you can define the list of environment varaibles using a table.

```javascript
Scenario: Single Container from Local Blueprint
  Given the following environment variables are set
    | key            | value                 |
    | CONSUL_VERSION | 1.8.0                 |
    | ENVOY_VERSION  | 1.14.3                |
  And I have a running blueprin
```

### There should be a `"<resource type>"` running called `"<name>"`
This statement allows you to write an assertion that a particular resources has been created. The first parameter is the type of the resource and the second the name.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then there should be a "container" running called "consul"
```

### The following resources should be running

This statement performs the same function as the previous but allows you top specify a table of resources. The table must start with a header row containing the columns `name` and `type`.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type      |
    | onprem                    | network   |
```

### A HTTP call to `"<uri>"` should result in the status `<http response code>`

This statement allows you to make an HTTP request to a URI and to check the HTTP status code returned. The given URI will be checked a number of times until the status code is matched or the check times out.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  And a HTTP call to "http://consul-http.ingress.shipyard.run:8500/v1/status/leader" should result in status 200
  And the response body should contain "10.6.0.200"
```

### And the response body should contain `"<value>"`
In addition to check the HTTP status code you can also check that a paricular text string is present in the response body.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  And a HTTP call to "http://consul-http.ingress.shipyard.run:8500/v1/status/leader" should result in status 200
  And the response body should contain "10.6.0.200"
```

## Matrix testing
In addition to simple tests it is possible to excute a test multiple times using a matrix of values. In the below example the Scenario would run once for every line specified in the `Examples` table.

Values from the `Examples` table can be interpolated at runtime by including the column name encapsulated by `<>` in your test statements. In the below example the environment variables `CONSUL_VERSION` and `ENVOY_VERSION` would be dynamically set to the values from the `Example` table.

```javascript
Scenario: Single Container from Local Blueprint with multiple runs
  Given the environment variable "CONSUL_VERSION" has a value "<consul>"
  And the environment variable "ENVOY_VERSION" has a value "<envoy>"
  And I have a running blueprint
  Then the following resources should be running
    | name                      | type      |
    | onprem                    | network   |
    | consul                    | container |
    | envoy                     | sidecar   |
    | consul-container-http     | ingress   |
  And a HTTP call to "http://consul-http.ingress.shipyard.run:8500/v1/status/leader" should result in status 200
  And the response body should contain "10.6.0.200"
  Examples:
    | consul            | envoy    |
    | 1.8.0             | 1.14.3   |
    | 1.7.3             | 1.14.3   |
  ```