# Puppeteer Tests for Convocate (formerly The Vatican )

[Puppeteer](https://pptr.dev/) is a [NodeJS](https://npmjs.org/package/puppeteer) Library designed to provide "a high-level API to control Chrome or Chromium over the [DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/)".
Specifically, the nature of asynchronous functions and promises make Puppeteer a solid choice for testing Single Page Applications (SPAs), such as those written in [ReactJS](https://reactjs.org/).

## Variables Needed

Variable Name | Variable Value
------------- | ---------------
BaseURL | The URL to test against. *ex*: **https://library.example.com**

## Running Puppeteer Tests

## Current Coverage

### Chrome Coverage

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
cd /QA_Tests/spec/vatican/puppeteer
```

Next, install the required node modules via:

```console
npm install
```

At this point, you will want to ensure your environment variables are in place. This can be done as follows:

```console
export BaseURL='https://test.library.com' \
```

You should be ready to run the tests, which can be done as follows:

```console
npm test
```

### Building and Running the Docker Container

**TODO: Create container for running these tests**

The 

### Expected Output

You should receive output from the script similar to the following if all tests pass:

```console
 PASS  spec/chrome/e2e.test.js (61.843 s)
  Convocate End to End Tests
    Website Returns Expected Content
      ✓ Page Title contains Convocate (4073 ms)
      ✓ Page has working Search Link (2242 ms)
      ✓ Page has working Instruction Link (2360 ms)
      ✓ Page has working Index of Documents link (2434 ms)
    Search End-to-End Tests
      ✓ Boxes can be checked in "Search By Topic" (6150 ms)
      ✓ Clearing the Selected Topic works (8294 ms)
      ✓ Search results are divided into columns (5571 ms)
      ✓ Entire documents can be accessed (21579 ms)
      ✓ Sorting functions work on results page (5023 ms)

Test Suites: 1 passed, 1 total
Tests:       9 passed, 9 total
Ran all test suites.
```

If the any of the tests fail, you can expect output similar to the following:

```console
 FAIL  spec/chrome/e2e.test.js (58.92 s)
  Convocate End to End Tests
    Website Returns Expected Content
      ✕ Page Title contains Convocate (4329 ms)
      ✓ Page has working Search Link (3028 ms)
      ✓ Page has working Instruction Link (2566 ms)
      ✓ Page has working Index of Documents link (2837 ms)
    Search End-to-End Tests
      ✓ Boxes can be checked in "Search By Topic" (8155 ms)
      ✓ Clearing the Selected Topic works (8099 ms)
      ✓ Search results are divided into columns (7483 ms)
      ✓ Entire documents can be accessed (15262 ms)
      ✓ Sorting functions work on results page (5054 ms)

  ● Convocate End to End Tests › Website Returns Expected Content › Page Title contains Convocate

    expect(received).toContain(expected) // indexOf

    Expected substring: "Convfocate"
    Received string:    "The Center for Civil and Human Rights | Convocate"

      32 |       await page.goto(url, { waitUntil: "networkidle0" });
      33 |       const pageTitle = await page.title();
    > 34 |       expect(pageTitle).toContain("Convfocate");
         |                         ^
      35 |     });
      36 |     test("Page has working Search Link", async () => {
      37 |       await page.goto(url, { waitUntil: "networkidle0" });

      at Object.<anonymous> (spec/chrome/e2e.test.js:34:25)

Test Suites: 1 failed, 1 total
Tests:       1 failed, 8 passed, 9 total
Snapshots:   0 total
Time:        60.322 s, estimated 62 s
Ran all test suites.
npm ERR! Test failed.  See above for more details.
```
