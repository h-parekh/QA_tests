# Puppeteer Tests for Usurper

[Puppeteer](https://pptr.dev/) is a [NodeJS](https://npmjs.org/package/puppeteer) Library designed to provide "a high-level API to control Chrome or Chromium over the [DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/)".
Specifically, the nature of asynchronous functions and promises make Puppeteer a solid choice for testing Single Page Applications (SPAs), such as those written in [ReactJS](https://reactjs.org/).

## Variables Needed

Variable Name | Variable Value
------------- | ---------------
BaseURL | The URL to test against. *ex*: **https://library.example.com**
TEST_USERNAME | The netid to test with. *ex*: **test_user**
TEST_PASSWORD | The password for the netid you are testing with. *ex*: **test_password**

## Running Puppeteer Tests

## Current Coverage

### Firefox Coverage

1. The homepage loads.
1. There is a "Log In" button that takes the user to a sign in page.
1. If a user is properly authorized, they can sign in and return to the main homepage.

### Prerequisites

In order to run this suite of tests locally, it is recommended to have [Docker](https://www.docker.com) installed on your local system. The built containers will have all of the requisites to build the tests and run the suite of tests.

#### Retreive the Latest Source Code

Testers will want to ensure they have the most up-to-date files from the Gitub repository.

### Running Puppeteer Tests Locally

The tests can all be run locally, without building or leveraging the Docker container. This is recommended if you are building new test files, and wish to quickly iterate on the new tests without building the Docker image each run. You will, however, need a working install of [NodeJS](https://nodejs.org/) to run tests locally.

To start, navigate to the `puppeteer` directory within the repository, as follows:

```console
cd /QA_Tests/spec/usurper/puppeteer/firefox
```

Next, install the required node modules via:

```console
PUPPETEER_PRODUCT=firefox npm install
```

At this point, you will want to ensure your environment variables are in place. This can be done as follows:

```console
export BaseURL='https://test.library.com' \
export TEST_USERNAME='test_user' \
export TEST_PASSWORD='test_password'
```

**Important Note: Testers should leverage one of the `t_heslib` test users that exist for testing purposes. Username and password combinations may be found in AWS Parameter Store. If you use a personal netid, the login test will fail due to no 2FA.**

You should be ready to run the tests, which can be done as follows:

```console
npm test
```

### Building and Running the Docker Container

Testers will need to build a version of the Docker container if they wish to execute tests in a fully clean and isolated environment. This is recommended prior to creating a pull request for new tests, as it will ensure that the suite has not been adversely impacted.

In order to build and run the Puppeteer test suite, run the following command on MacOS and Linux:

```console
cd /QA_tests/spec/usurper/puppeteer/firefox

docker run --cap-add=SYS_ADMIN -e "BaseURL={{BaseURL}}" -e "TEST_USERNAME=test_user" -e "TESTP_PASSWORD=test_password" -it $(docker build -q .)
```

### Expected Output

You should receive output from the script similar to the following if all tests pass:

```console
 PASS  spec/login.test.js (32.219 s)
  Website End to End Tests
    Website Returns Expected Content
      ✓ Page Title contains Hesburgh (5715 ms)
      ✓ Page has working login button (6460 ms)
    Login End-to-End Tests
      ✓ Valid users are logged in (16152 ms)

Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total
```

If the any of the tests fail, you can expect output similar to the following:

```console
 FAIL  spec/login.test.js (20.147 s)
  Website End to End Tests
    Website Returns Expected Content
      ✕ Page Title contains Hesburgh (3341 ms)
      ✓ Page has working login button (3362 ms)
    Login End-to-End Tests
      ✓ Valid users are logged in (10975 ms)

  ● Website End to End Tests › Website Returns Expected Content › Page Title contains Hesburgh

    expect(received).toContain(expected) // indexOf

    Expected substring: "Nachos"
    Received string:    "Hesburgh Libraries"

      29 |         await page.goto(url, {waitUntil: 'networkidle0'});
      30 |         const pageTitle = await page.title();
    > 31 |         expect(pageTitle).toContain('Nachos');
         |                           ^
      32 |       })
      33 |       test('Page has working login button', async () => {
      34 |         await page.goto(url, {waitUntil: 'networkidle0'});

      at Object.<anonymous> (spec/login.test.js:31:27)

Test Suites: 1 failed, 1 total
Tests:       1 failed, 2 passed, 3 total
Snapshots:   0 total
Time:        21.436 s
Ran all test suites.
npm ERR! Test failed.  See above for more details.
```
