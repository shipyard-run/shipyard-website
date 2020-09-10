---
id: test
title: Test
---

Run functional tests for the blueprint, this command will start the Shipyard blueprint specified by the location `[blueprint]` and run any functional tests specified in the `test` subdirectory. 

For more information, take a look at the [Testing Tutorial](/docs/tutorials/testing)

## Command Usage
```shell
Run functional tests for the blueprint, this command will start the shipyard blueprint

Usage:
  shipyard test [blueprint]

Flags:
      --force-update         When set to true Shipyard will ignore cached images or files and will download all resources
  -h, --help                 help for test
      --purge                When set to true Shipyard will remove any cached images or blueprints
      --test-folder string   Specify the folder containing the functional tests.
```

## Example test

The following example shows a test which would start a blueprint, and assert that the defined resources are created and running, as well as applications defined by the blueprint are accessible and functioning correctly by checking the HTTP response. For more information on the statements please see the [Testing Statements](#testing-statements) section below.

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

The `--purge` flag will remove all downloaded images, Helm charts, or external blueprints after running the tests. This is to ensure that each scenario has no cached dependencies from a previous test.

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

When writing features the following statements can be used:

### Setup

#### I have a running blueprint

The statement `I have a running blueprint` creates the resources in the blueprint.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
```

#### I have a running blueprint using version `"<version>"`

This statement starts a blueprint using a specific version of Shipyard.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint using version "0.1.2"
```

#### I have a running blueprint at path `"<path>"`

This statement allows you to run a blueprint at the given path, you can use this in combination with the
main blueprint for the tests. This can be useful to setup test data, etc.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  And I have a running blueprint at path "./testsetup/container"
```

#### I have a running blueprint at path `"<path>"` using version `"<version>"`

Starts a blueprint at the given path using a specific Shipyard version. You can use [Matrix testing](#matrix-testing) with these statements
to test your blueprints with different Shipyard versions.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint at path "./testsetup/container" using version "<version>"
  Examples:
    | consul            | envoy    |
    | 1.8.0             | 1.14.3   |
    | 1.7.3             | 1.14.3   |
```

#### the environment variable `"<key>"` has a value `"<value>"`

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

When you run your tests the environment variable will be set and interpolated before the blueprint is created.

### The following environment variables are set

This statement is similar to the previous except you can define the list of environment variables using a table.

```javascript
Scenario: Single Container from Local Blueprint
  Given the following environment variables are set
    | key            | value                 |
    | CONSUL_VERSION | 1.8.0                 |
    | ENVOY_VERSION  | 1.14.3                |
  And I have a running blueprint
```

#### the following shipyard variables are set

This statement allows you to set the value for any Shipyard variables which may be used by the blueprint

```
Scenario: Single Container from Local Blueprint
  Given the following shipyard variables are set
    | key            | value                 |
    | consul_version | 1.8.0                 |
    | envoy_version  | 1.14.3                |
  And I have a running blueprint
```

When you run your tests the environment varaible will be set and interpolated before the blueprint is created.

### Assertion

#### there should be a `"<resource type>"` running called `"<name>"`

This statement allows you to write an assertion that a particular resources has been created. The first parameter is the type of the resource and the second the name.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then there should be a "container" running called "consul"
```

#### the following resources should be running

This statement performs the same function as the previous but allows you top specify a table of resources. The table must start with a header row containing the columns `name` and `type`.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type      |
    | onprem                    | network   |
```

#### a HTTP call to `"<uri>"` should result in the status `<http response code>`

This statement allows you to make an HTTP request to a URI and to check the HTTP status code returned. The given URI will be checked a number of times until the status code is matched or the check times out.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then a HTTP call to "http://consul-http.ingress.shipyard.run:8500/v1/status/leader" should result in status 200
  And the response body should contain "10.6.0.200"
```

#### the response body should contain `"<value>"`

In addition to check the HTTP status code you can also check that a paricular text string is present in the response body.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then a HTTP call to "http://consul-http.ingress.shipyard.run:8500/v1/status/leader" should result in status 200
  And the response body should contain "10.6.0.200"
```

#### the info `"<jsonPath>"` for the running `"<type>"` called `"<name>"` should equal `"<value>"`

This statement allows you to check the value in the resource info for the given type and name. You can query any of the parameters and values
such as ports, volumes, networks, startup commands, etc.


```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then there should be a "container" running called "consul"
  And the info "{.HostConfig.PortBindings['8500/'][0].HostPort}" for the running "container" called "consul" should equal "8500"
```

#### the info `"<jsonPath>"` for the running `"<type>"` called `"<name>"` should contain `"<value>"`

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then there should be a "container" running called "consul"
  And the info "{.HostConfig.PortBindings['8500/'][0].HostPort}" for the running "container" called "consul" should contain "85"
```

#### the info `"<jsonPath>"` for the running `"<type>"` called `"<name>"` should exist`

Checks that there is a value at the given jsonPath for the type and that the value is not null

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then there should be a "container" running called "consul"
  And the info "{.HostConfig.PortBindings['8500/'][0].HostPort}" for the running "container" exists"
```


#### when I run the command `"<command>"`

Allows a command or executable script to be used as an assertion. The test runner executes the command and stores the result, the value
of which can be asserted by future statements.

```javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then there should be a "container" running called "consul"
  When I run the command "curl https://localhost:8500/v1/status"
  Then I expect the exit code to be 0
```

#### when I run the script

Executes an inline script the results of which can be used for a future assertion.

~~~javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then there should be a "container" running called "consul"
  When I run the script
    ```
      #!/bin/bash
      curl http://localhost:8500/v1/status
    ```
  Then I expect the exit code to be 0
~~~

#### I expect the exit code to be `<code>`

Assertion statement to be used with the script or command execution statement.

~~~javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then there should be a "container" running called "consul"
  When I run the script
    ```
      #!/bin/bash
      curl http://localhost:8500/v1/status
    ```
  Then I expect the exit code to be 0
~~~

#### I expect the response to contain `"<value>"`

Assertion statement to be used with the script or command execution statement.

This assertion may contain a partial string which is matched in the output from the command or script, or
can be a simple regular experession.

~~~javascript
Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then there should be a "container" running called "consul"
  When I run the script
    ```
      #!/bin/bash
      curl http://localhost:8500/v1/status
    ```
  Then I expect the exit code to be 0
  And I expect the response to contain "8500"
  And I expect the response to contain "`[0-9]{4}`"
~~~

### Matrix testing

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

  ### Example Resource Info

  ```json
  [
    {
        "Id": "12ef40e9fe223f6de4b35701bed261975aed38ca0b5639f5c69d788ceceff384",
        "Created": "2020-08-15T07:55:19.2839915Z",
        "Path": "/entrypoint.sh",
        "Args": [
            "/etc/docker/registry/config.yml"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 31362,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2020-08-15T07:55:19.556512Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:2d4f4b5309b1e41b4f83ae59b44df6d673ef44433c734b14c1c103ebca82c116",
        "ResolvConfPath": "/var/lib/docker/containers/12ef40e9fe223f6de4b35701bed261975aed38ca0b5639f5c69d788ceceff384/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/12ef40e9fe223f6de4b35701bed261975aed38ca0b5639f5c69d788ceceff384/hostname",
        "HostsPath": "/var/lib/docker/containers/12ef40e9fe223f6de4b35701bed261975aed38ca0b5639f5c69d788ceceff384/hosts",
        "LogPath": "/var/lib/docker/containers/12ef40e9fe223f6de4b35701bed261975aed38ca0b5639f5c69d788ceceff384/12ef40e9fe223f6de4b35701bed261975aed38ca0b5639f5c69d788ceceff384-json.log",
        "Name": "/docker-registry.container.shipyard.run",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Capabilities": null,
            "Dns": null,
            "DnsOptions": null,
            "DnsSearch": null,
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "shareable",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": null,
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": null,
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/41e99680e9e8515f09bd630b2c1c49500a05a8c3fbc28d7f07907941dcd4536e-init/diff:/var/lib/docker/overlay2/98bff9ef7ca85776c6de7e3966efb47ff675a7f39841812590c0f08024a5e6f6/diff:/var/lib/docker/overlay2/2c2723404c2f0bcd1e1d266a87baa2b00b1d05b81b39727d0e0df55fe38244a6/diff:/var/lib/docker/overlay2/13744e9a9a26f3abced77f48ac025ca19d420788dba2664cc16eb1a9ae0fed87/diff:/var/lib/docker/overlay2/3e51403fbee392da29a33b1b04e4a4edb63bb814104b54c8ab274451ca920bb7/diff:/var/lib/docker/overlay2/f4e46ecd765e54f0421ace91045c54d8916e98c6667d18eb72f5a5c8b3ee37ca/diff",
                "MergedDir": "/var/lib/docker/overlay2/41e99680e9e8515f09bd630b2c1c49500a05a8c3fbc28d7f07907941dcd4536e/merged",
                "UpperDir": "/var/lib/docker/overlay2/41e99680e9e8515f09bd630b2c1c49500a05a8c3fbc28d7f07907941dcd4536e/diff",
                "WorkDir": "/var/lib/docker/overlay2/41e99680e9e8515f09bd630b2c1c49500a05a8c3fbc28d7f07907941dcd4536e/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [
            {
                "Type": "volume",
                "Name": "92d6f9cfce128c3df23dcb5f5622f17e3ae2d94a2bd7c202f564f28970aebcf1",
                "Source": "/var/lib/docker/volumes/92d6f9cfce128c3df23dcb5f5622f17e3ae2d94a2bd7c202f564f28970aebcf1/_data",
                "Destination": "/var/lib/registry",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            }
        ],
        "Config": {
            "Hostname": "docker_registry",
            "Domainname": "",
            "User": "",
            "AttachStdin": true,
            "AttachStdout": true,
            "AttachStderr": true,
            "ExposedPorts": {
                "5000/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "/etc/docker/registry/config.yml"
            ],
            "Image": "registry:2",
            "Volumes": {
                "/var/lib/registry": {}
            },
            "WorkingDir": "",
            "Entrypoint": [
                "/entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {}
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "ea49aece32ef31f629762575fda1665e84e55a5aa5419131f7c04e75926e6a28",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "5000/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/ea49aece32ef",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {
                "local": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "12ef40e9fe22"
                    ],
                    "NetworkID": "87bcf0c4fd53cd692d6f74470e70bc47844661b6a00847576ccd01ceac077a2c",
                    "EndpointID": "4fd2e0cfc32fb3e84a5cae643839b8ca1217005967a477d18eaa3f3dff68083a",
                    "Gateway": "10.5.0.1",
                    "IPAddress": "10.5.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:0a:05:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
```
