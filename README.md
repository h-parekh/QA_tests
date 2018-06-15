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
4. Configure aws profiles as explained below
5. Install [VNC viewer](https://www.realvnc.com/en/connect/download/viewer/)

### Setting up aws profiles

1. Get details from AWS console (This is a temporary implementation until the values get parameterized)
  1. Login to libnd account via AWS console with <your_aws_account_name>, go to IAM services and search for <your_aws_account_name> under 'Users' tab.
  2. Once you are on the summary page of your account, click 'Create access key'
  3. Copy values of 'Access key ID' and 'Secret access key' in a temporary file (we will use these values for setup)
  4. Also copy value of 'Assigned MFA device'
  5. Switch to an admin account in testlibnd and go to the 'ecsTaskExecutionRole' in IAM roles
  6. copy value of 'Role ARN'


2. Configure aws cli with your AWS libnd account
```console
$ aws configure --profile <your_aws_account_name>-libnd
AWS Access Key ID [None]: (Use value copied from step 1.3. above)
AWS Secret Access Key [None]: (Use value copied from step 1.3. above)
Default region name [None]: us-east-1
Default output format [None]: json
```

3. Configure aws cli with another profile called 'testlibnd-ecs-ecsTaskExecutionRole'.
```console
$ aws configure --profile testlibnd-ecs-ecsTaskExecutionRole
AWS Access Key ID [None]:
AWS Secret Access Key [None]:
Default region name [None]: us-east-1
Default output format [None]: json
```

4. Open '~/.aws/config' in an editor and add 'source_profile', 'mfa_serial' and 'role_arn' fields to the 'testlibnd-ecs-ecsTaskExecutionRole' profile
```console
[profile testlibnd-ecs-ecsTaskExecutionRole]
region = us-east-1
source_profile = <your_aws_account_name>-libnd
mfa_serial = Use value from step 1.4. explained above
role_arn = Use value from step 1.6. explained above
```

5. Export profile
```console
export AWS_PROFILE=testlibnd-ecs-ecsTaskExecutionRole
```

You may also add a default export to the configuration file of your shell
```console
echo "export AWS_PROFILE=testlibnd-ecs-ecsTaskExecutionRole" > ~/.zshrc
```

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

To see all available input variables and examples:
```console
$ cd /path/to/QA_tests
$ ./bin/run_tests -h
```
### QA testers: Example for running tests from master branch using Docker
```console
$ cd /path/to/QA_tests
$ docker-compose run -e SKIP_CLOUDWATCH=true qa-tests-master spec/curate/functional/func_curate_spec.rb
```
### QA developers: Example for running tests from non-master branch using Docker
1. Start up Selenium hub and the nodes
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

4. Update specs and run them
```console
$ git checkout -b <new_dev_branch>
$ <do development stuff>
$ RUNNING_ON_LOCAL_DEV=true SKIP_CLOUDWATCH=true CHROME_HEADLESS=true bin/run_tests spec/curate/functional/func_curate_spec.rb
```
*  Create a PR your local QA_tests branch to merge into master
*  Wait for qa-tests:latest to be updated on [Docker hub](https://hub.docker.com/r/ndlib/qa-tests/)
*  You can now use new specs with docker-compose as described in previous section

### Testing on AWS
#### Export the correct profile:
```console
export AWS_PROFILE=testlibnd-ecs-ecsTaskExecutionRole
```

#### Update the trigger file 'data/aws_ecs_trigger.json' and call the ECS task definition
```console
aws ecs run-task --cli-input-json file://spec/curate/aws_ecs_trigger_curate.json
```

#### Triggering from Jenkins CI

To do: https://jira.library.nd.edu/browse/DLTP-1390


#### ENV variables and available toggles:
RUNNING_ON_LOCAL_DEV: This environment variable tells the AwsSsmHandler module whether its
running on a local machine or in AWS ECS.
If you're writing/running tests from local set RUNNING_ON_LOCAL_DEV=true
```console
docker-compose run -e RUNNING_ON_LOCAL_DEV=true qa-tests-dev spec/curate/functional/func_curate_spec.rb
```

TOKEN_CODE: The 6 digit code for multi factor authentication
```console
docker-compose run -e RUNNING_ON_LOCAL_DEV=true -e TOKEN_CODE=010101 qa-tests-dev spec/curate/functional/func_curate_spec.rb
```

SKIP_CLOUDWATCH: By default we notify CloudWatch of test events. In some cases,
this is not desired (e.g. local development).
So you can set SKIP_CLOUDWATCH=true ENV variable to not notify CloudWatch.
```console
docker-compose run -e SKIP_CLOUDWATCH=true qa-tests-dev spec/curate/functional/func_curate_spec.rb
```

SKIP_VERIFY_NETWORK_TRAFFIC: By default we verify network traffic of all
scenarios. In some cases, this is not desired (e.g. testing beta sites).
So you can set SKIP_VERIFY_NETWORK_TRAFFIC=true ENV variable to not
verify network traffic.
```console
docker-compose run -e SKIP_VERIFY_NETWORK_TRAFFIC=true qa-tests-dev spec/curate/functional/func_curate_spec.rb
```

USE_CONTENTFUL_SPACE: This toggle is only used for and required for contentful testing. When testing contentful, there are two options for contentful space: prod and prep. In order to use these spaces, the user needs a token from the shared drive which differs for each space. So, you must define which space you want for your test in the command line.
```console
docker-compose run -e USE_CONTENTFUL_SPACE=prod qa-tests-dev spec/curate/functional/func_curate_spec.rb
```

VERSION_NUMBER: When testing usurper, you must input the version number for the version of the site you want to test so that the tests run accurately and small design changes
from version to version do not cause failures.
```console
docker-compose run -e VERSION_NUMBER=v2017.2 qa-tests-dev spec/curate/functional/func_curate_spec.rb
```

RELEASE_NUMBER: This toggle is only used for contentful_testing. When testing contentful, you must provide a release number to define the stack of deployed VERSION_NUMBER(s).
```console
docker-compose run -e RELEASE_NUMBER=r20170922 -e VERSION_NUMBER=v2017.2 qa-tests-dev spec/curate/functional/func_curate_spec.rb
```

SWAGGER_LOCATION: Used to specify the swagger definition to use for integration tests, you must provide
a value from either 'definitions' or 'gateway'.
'definitions': Expects swagger definition in `definitions/swagger.yml` of the API's github repo
'gateway': Expects swagger definition in `deploy/gateway.yml` of the APIS's github repo
```console
docker-compose run -e  SWAGGER_LOCATION=gateway qa-tests-dev spec/curate/functional/func_curate_spec.rb
```

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

## Running Web Rennovation Audit

From the command line:

```console
rake webRennovation:accessibility_audit
```

This will run the necessary steps to generate the accessibility report. It is comprised of multiple rake tasks. Run `rake -T` to see the list of tasks. Run `rake -P` for the prerequisites that are run.
