[![Build Status](https://travis-ci.org/ndlib/QA_tests.svg?branch=master)](https://travis-ci.org/ndlib/QA_tests)

# NDlib QA Tests
> A place to collect all types of test suites for Hesburgh Libraries web application and APIs

These tests are dockerized with their dependent binaries and gems, and are running in AWS using [ECS](https://aws.amazon.com/ecs/) and [AWS Parameter store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html)
You can run these tests against the environments specified in the application's YAML config file

## Setup Notes
Your local machine will need the following setup to be able to run and write tests

1. Git for version control
2. [Docker](https://docs.docker.com/install/) version 18 or higher
3. AWS [CLI](https://aws.amazon.com/cli/)
4. Configure ENV variables with an IAM role that can read parameters from parameter store in testlibnd account. See [guidance](managing_aws_profiles.md) if needed.
5. Optional - Install [VNC viewer](https://www.realvnc.com/en/connect/download/viewer/)

## Writing Tests

### Logging

Many of the events are already logged to the appropriate location (e.g. when you click a link, visit a page, submit a form).
[See ExampleLogging for examples](./spec/spec_support/example_logging.rb).

You can add custom logging within a spec by calling the `current_logger` method. You can write log messages with the following methods on `current_logger`:

* debug
* info
* warn
* error
* fatal

#### Example

```ruby
it 'will log a single line' do
  current_logger.debug(context: "hello", message: "something custom")
end

it 'will accept a block, wrapping the calling of the block with a starting the context and ending the context log message' do
  current_logger.debug(context: "remote_request", url: "https://google.com") do
    make_remote_request
  end
end
```

### Tagging

Usage: We use tag filtering to control which scenarios we run. It can be a simple name
or a name:value pair. Tagging a scenario with a simple name is the equivalent to a "simple_name:true" name:value pair.

We can define any new tags by appending it to a scenario. No additional config is needed.
Here are some we should use consistently across all tests:
* :smoke_test - checks application and dependent system availability
* :read_only - will not make add/update to the underlying data (aside from login counts)
* :nonprod_only - should not be run in production
* :prod_only - should not be run in non-production
* :regression_test - covers an important regression test
* :authentication_required - requires logging into CAS

#### Example
```ruby
  scenario 'Scenario Name', :smoke_test, :read_only do
    # Scenario actions here
  end
```

#### Usage
To only run tests that are tagged with 'smoke_test' pass it along to rspec command with --tag option
```console
rspec spec/curate/functional/func_curate_spec.rb --tag smoke_test
```

To run multiple scenarios with different tags, pass them as separate tags to rspec command.
Rspec will run a union of the tags, i.e. all scenarios tagged with either of the tags will be run.
```console
rspec spec/curate/functional/func_curate_spec.rb --tag smoke_test --tag read_only
```

To exclude scenarios associated with a tag:
```console
rspec spec/curate/functional/func_curate_spec.rb --tag ~read_only
```
More details here: https://www.relishapp.com/rspec/rspec-core/v/2-4/docs/command-line/tag-option

## Running Tests

### Testing on your local machine

#### Start docker containers
1. Run this command to start docker nodes (`-d` will start them up in background)
```console
$ cd /path/to/QA_tests
$ docker-compose -f selenium_grid/docker-compose.yml up -d
```
2. Verify the cluster is up:
```console
$ docker-compose -f selenium_grid/docker-compose.yml ps
```
You will see 3 containers in 'Up' state
```console
Name                       Command           State                Ports
------------------------------------------------------------------------------------------------
seleniumgrid_chrome_node_1    /opt/bin/entry_point.sh   Up      4578/tcp, 0.0.0.0:4578->5900/tcp
seleniumgrid_firefox_node_1   /opt/bin/entry_point.sh   Up      4577/tcp, 0.0.0.0:4577->5900/tcp
seleniumgrid_selenium_hub_1   /opt/bin/entry_point.sh   Up      0.0.0.0:4444->4444/tcp
```
3. (Optionally) Open VNC viewer for the node you are testing against:
For example in this case, to connect to the 'seleniumgrid_chrome_node_1' connect to: `127.0.0.1:4578`
It will ask you for a password, and the value is 'secret' (literally)
Once you're connected you will see a blank window with Ubuntu symbol

#### Check the ENVIRONMENT variables you may need
To see all available input variables and examples:
```console
$ cd /path/to/QA_tests
$ ./bin/run_tests -h
```
### QA testers: Example for running tests from master branch using Docker
```console
$ cd /path/to/QA_tests
$ git pull
$ USE_LOCALHOST_GRID=true CHROME_HEADLESS=true ENVIRONMENT=pprd SKIP_CLOUDWATCH=true RUNNING_ON_LOCAL_DEV=true bin/run_tests spec/curate/functional/func_curate_spec.rb
```
### QA developers: Example for running tests from non-master branch using Docker
```console
$ git checkout -b <new_dev_branch>
$ <do development stuff>
$ USE_LOCALHOST_GRID=true SKIP_CLOUDWATCH=true RUNNING_ON_LOCAL_DEV=true bin/run_tests spec/curate/functional/func_curate_spec.rb
```
*  Create a PR your local QA_tests branch to merge into master
*  Wait for qa-tests:latest to be updated on [Docker hub](https://hub.docker.com/r/ndlib/qa-tests/)
*  You can now use new specs with docker-compose as described in previous section

#### Stop docker containers
1. Run this command to stop docker nodes
```console
$ cd /path/to/QA_tests
$ docker-compose -f selenium_grid/docker-compose.yml stop
```
2. Verify the cluster is down:
```console
$ docker-compose -f selenium_grid/docker-compose.yml ps
```

### Testing on AWS

#### Update the trigger file 'data/aws_ecs_trigger.json' and call the ECS task definition
```console
aws ecs run-task --cli-input-json file://spec/curate/aws_ecs_trigger_curate.json
```

#### Triggering from Jenkins CI
Currently not supported, pending https://jira.library.nd.edu/browse/DLTP-1390

## Running Rubocop

Rubocop is install and configured to report any offenses in code. It is recommended to run rubocop on local machine before sending in pull request. Here is basic usage

```console
cd /path/to/QA_tests
bundle exec rubocop
```

It is possible to auto-correct certain offenses. it is experimental so use it with caution.

```console
cd /path/to/QA_tests
rubocop -a
```
