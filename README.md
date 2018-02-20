# NDlib QA Tests
> A place to collect all types of test suites for HesLib web application and APIs

These tests will be deployed to the remote machine testcontroller01.library.nd.edu
You can run these tests against the environments specified in the application's YAML config file

## Setup Notes
Your local machine will need the following setup to be able to run these tests from the local machine.

1. Git for version control
2. Bundler for managing Ruby libraries
3. Rbenv for managing versions of Ruby
4. Ruby 2.3.1
5. Capybara 2.10.1 - for testing web applications
6. Phantomjs 2.1.1 - for supporting capybara/poltergeist to capture screenshots
7. Poltergeist 1.11.0 - chosen web driver for using with capybara
8. Nokogiri 1.6.8.1 - for XML tree parsing and navigation
9. Verify that `ssh app@testcontroller01.library.nd.edu` works
10. Chrome (Version 60.* or above)
11. chromedriver (Version 2.3.1 or above)

## Installation Phantomjs and Phantomenv install
PhantomJS is a headless WebKit scriptable with a JavaScript API. It has fast and native support for various web standards: DOM handling, CSS selector, JSON, Canvas, and SVG.
Install phantomjs
``` console
brew install phantomjs
```
### phantomenv

rbenv, but for PhantomJS.

To install the latest stable release:

```console
git clone -b v0.0.10 https://github.com/boxen/phantomenv.git ~/.phantomenv
```
Then add the following to your shell config at the end:

```console
export PATH="$HOME/.phantomenv/bin:$PATH"
eval "$(phantomenv init -)"
```
To setup through Boxen uses https://github.com/boxen/puppet-phantomjs to set up phantom JS which is a wrapper around https://github.com/boxen/phantomenv

## Setting up shared drive
These tests will need to access a shared drive that has test data

1. From the Finder, hit Command+K
2. Enter the path cifs://library.corpfs.nd.edu/DCNS/ and click ‘Connect’
3. Enter your login credentials and click “OK”
4. The drive is now mounted, but continue on to map for system reboot persistence
5. Now enter into System Preferences, from the Apple menu
6. Click on 'Users & Groups'
7. Click on “Login Items”
8. Click on the + button to add another login item
9. Locate the network drive /DCNS/Library/Departmental/Infrastructure/vars/QA
10. Click “Add” and exit
11. Create a new directory and setup a soft link
``` console
mkdir ~/test_data
ln -s /Volumes/DCNS/Library/Departmental/Infrastructure/vars/QA ~/test_data
```

## Deploying master branch from local to remote testcontroller01
``` console
cd git/QA_tests
git checkout master
git pull
cap production deploy
```
?? We may want to consider setting up Capistrano to deploy non-master branches

## Writing New Tests

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

### Chatter on the Terminal

When you are writing new tests, you will notice a lot of chatter in the terminal. There are three possible things being reported:

1) Logging for the tests we wrote
2) Deprecation warning
3) Other developers adding output for logging their code

When writing the tests, we need to fix the deprecation warnings. In order to fix them, we need to know they exist.

As such, you should run the specs so that our tests are not writing log information to STDOUT.

## Running Tests

To run the tests use the `./bin/run_tests` command. For more information on available parameters `./bin/run_tests -h`.

### Examples

#### Testing on the remote

This will run all of the tests.
```console
$ ssh app@testcontroller01.library.nd.edu
$ cd /home/app/QA_tests/current
$ ./bin/run_tests
```

This will run the `func_curate_spec.rb` specific functional test of Curate.
``` console
$ ssh app@testcontroller01.library.nd.edu
$ cd /home/app/QA_tests/current
$ ./bin/run_tests spec/curate/functional/func_curate_spec.rb
```

#### Testing on your local machine

```console
$ cd /path/to/QA_tests
$ ./bin/run_tests spec/curate/functional/func_curate_spec.rb
```

#### Triggering from Jenkins CI

We have all specs setup to run from a Jenkins job which will trigger the requested spec from the remote machine testcontroller01
In order to trigger a test you will need to identify values of the following parameters and append to the URL:
* token: Check with QA Admin
* cause: Provide some context of test trigger (Ex: AWS, remote_trigger, your_name)
* Task: 'run_test' (Do not use anything else)
* TestLoggerLogLevel: 'debug' 'info' 'warn' 'error' 'fatal' (Choose any one)
* AppToTest: Folder name of the application spec you want to test (Ex: 'curate', 'osf')
* EnvUnderTest: The environment you want to test against (Ex: 'prod', 'prep', 'https://curate.nd.edu')
* DeployTarget 'production' (Do not use anything else)

Example URL
https://jenkins.library.nd.edu/jenkins/job/QA_tests_deploy_and_run/buildWithParameters?token=garfield&cause=remote_trigger&Task=run_test&TestLoggerLogLevel=info&AppToTest=osf&EnvUnderTest=prod&DeployTarget=production

Available toggles (not supported with Jenkins CI):

SKIP_CLOUDWATCH: By default we notify CloudWatch of test events. In some cases,
this is not desired (e.g. local development).
So you can set SKIP_CLOUDWATCH=true ENV variable to not notify CloudWatch.

```console
SKIP_CLOUDWATCH=true ./bin/run_tests spec/curate/functional/func_curate_spec.rb
```

SKIP_VERIFY_NETWORK_TRAFFIC: By default we verify network traffic of all
scenarios. In some cases, this is not desired (e.g. testing beta sites).
So you can set SKIP_VERIFY_NETWORK_TRAFFIC=true ENV variable to not
verify network traffic.
```console
SKIP_VERIFY_NETWORK_TRAFFIC=true ./bin/run_tests spec/curate/functional/func_curate_spec.rb
```

CHROME_HEADLESS: Using this toggle allows you to run tests using Selenium webdriver and Chrome headless.
NOTE: This ecosystem is still work in progress and some assertions will fail (ex: status_code, response_headers)
```console
CHROME_HEADLESS=true ./bin/run_tests spec/curate/functional/func_curate_spec.rb
```

USE_CONTENTFUL_SPACE: This toggle is only used for and required for contentful testing. When testing contentful, there are two options for contentful space: prod and prep. In order to use these spaces, the user needs a token from the shared drive which differs for each space. So, you must define which space you want for your test in the command line.
```console
USE_CONTENTFUL_SPACE=prod
```

VERSION_NUMBER: When testing usurper, you must input the version number for the version of the site you want to test so that the tests run accurately and small design changes
from version to version do not cause failures.
```console
VERSION_NUMBER=v2017.2
```

RELEASE_NUMBER: This toggle is only used for contentful_testing. When testing contentful, you must provide a release number to define the stack of deployed VERSION_NUMBER(s).
```console
RELEASE_NUMBER=r20170922
```

SWAGGER_LOCATION: Used to specify the swagger definition to use for integration tests, you must provide
a value from either 'definitions' or 'gateway'.
'definitions': Expects swagger definition in `definitions/swagger.yml` of the API's github repo
'gateway': Expects swagger definition in `deploy/gateway.yml` of the APIS's github repo
# Using Docker
## Pre-requisites:
* Install Docker https://docs.docker.com/install/
* ensure /Volumes/DCNS is mounted

### Example for running tests from master branch using Docker - For QA testers
* cd <QA_tests>
* docker-compose run -e SKIP_CLOUDWATCH=true qa-tests-master spec/curate/functional/func_curate_spec.rb

### Example for running tests from local branch (NOT MASTER) - For QA developers
* cd <QA_tests>
* git checkout -b <dev branch>
* <do development stuff>
* docker-compose run -e SKIP_CLOUDWATCH=true qa-tests spec/curate/functional/func_curate_spec.rb
* Create a PR your local QA_tests branch to merge into master
* Wait for qa-tests:latest to be updated at https://hub.docker.com/r/ndlib/qa-tests/
* You can now use new specs with docker-compose as described in previous section

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
