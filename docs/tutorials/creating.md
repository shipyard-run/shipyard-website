---
id: creating
title: Creating Blueprints
---

Testing blueprints in Shipyard can be completed using the `shipyard test` command. The `test` command allows you to write functional tests using the [Gherkin](https://cucumber.io/docs/gherkin/reference/) functional testing language. When running a test Shipyard will first start the blueprint then it will execute the tests before cleaning up and destroying any resources.

## Simple Example

If you take a look at the example in the folder [https://github.com/shipyard-run/shipyard-website/tree/main/examples](https://github.com/shipyard-run/shipyard-website/tree/main/examples/testing/simple_container).

You will see a simple blueprint which contains a single resource which creates a container running `fake-service`.

** container.hcl **
```javascript
container "app" {
  image   {
    name = "nicholasjackson/fake-service:v0.13.2"
  }

  port {
    local = 9090
    remote = 9090
    host = 9090
  }
}
```

There is also a sub folder `./test` which contains a single feature file container.feature.

** test/container.feature **
```javascript
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
```

`.feature` files are where you write your tests, they are written using the Gherkin syntax. There is no rule on the number of feature files you can have, you may choose to put all your tests in a single file, or you may choose to split these up into separate files.

At the start of the file you will see the `Feature` declaration, this has no direct functional impact on the test but you should use this to describe what these tests are doing. You can be as brief or as detailed as you like here.

```javascript
Feature: Docker Container
  In order to test Shipyard creates containers correctly
  I should apply a blueprint which defines a simple container setup
  and test the resources are created correctly
```

Next is the `Scenario`, for every scenario, Shipyard will create the resources defined in the blueprint, at the end of the scenario it will destroy any created resources. The scenario is where you will define the tests you would like to execute.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type      |
    | app                       | container |
  And a HTTP call to "http://app.container.shipyard.run:9090" should result in status 200
```

Let's walk through this scenario line by line.

The first line starts with the Keyword `Scenario`, followed by the name of the scenario. It is advisable to add descriptive titles for your scenarios so when looking at test output you can understand what the test is intending.

```javascript
Scenario: Single Container from Local Blueprint
```

Then we have the next line, this is required for all tests as it tells Shipyard to create the resources.

```javascript
Given I have a running blueprint
```

Then we have the assertion block `Then the following resources should be running`, this is followed by a table. There are two ways to write a check to see if resources have been succesfully created in Shipyard tests. The first way is the below example where you create a table containg the resources and the names.

```javascript
Then the following resources should be running
  | name                      | type      |
  | app                       | container |
```

The second way is to use a single line statement, for example:

```javascript
Then there should be a "container" running called "app"
```

The approach you take is entirely up to you and what you feel gives your tests the most expression, in both cases. Shipyard test will validate that the named resource has been created and is healthy. The test will immediately fail should any resources defined in these statements not be running.

Finally there is an assertion to check a HTTP endpoint, this test would call the URL `http://app.container.shipyard.run:9090` and check that the status code `200` has been returned. Shipyard will test the URL a number of times incase the service takes a little while to start. If after the check period has elapsed the required status code has not been returned then the test will fail.

```javascript
And a HTTP call to "http://app.container.shipyard.run:9090" should result in status 200
```

Putting this all together you get the following output. You will see that Shipyard creates the referenced resources, executes the tests and then destroys the resources when finished.

For more information on testing features see the Shipyard CLI [Test](http://localhost:3000/docs/commands/test) documentation.

```shell
➜ shipyard test ./simple_container
Feature: Docker Container
  In order to test Shipyard creates containers correctly
  I should apply a blueprint which defines a simple container setup
  and test the resources are created correctly

  Scenario: Single Container from Local Blueprint                                           # simple_container/test/container.feature:6
    Given I have a running blueprint                                                        # test.go:141 -> *CucumberRunner
    Then the following resources should be running                                          # test.go:189 -> *CucumberRunner
      | name | type      |
      | app  | container |
    And a HTTP call to "http://app.container.shipyard.run:9090" should result in status 200 # test.go:277 -> *CucumberRunner


1 scenarios (1 passed)
3 steps (3 passed)
6.1739524s
```