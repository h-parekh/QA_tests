# QA Tests for Convocate

## Variables Needed

Variable Name | Variable Value
------------- | ---------------
BaseURL | The URL to test against. *ex*: **convocate.example.com**

## Testing with [Newman CLI](https://github.com/postmanlabs/newman)

1. TBD

## Testing Front End with [Selenium](https://www.seleniumhq.org/)

### Current Chrome Coverage

1. The homepage loads.
1. The About link exists and functions.
1. The proper banner exists and functions.
1. The Contact link exists and functions.
1. The How To Use link exists and functions.
1. The Index of Documents link exists and functions.
1. The Project Partners link exists and functions.

### Prerequisites

In order to run this suite of tests locally, you will need to have [Docker](https://www.docker.com) installed on your local system. The built containers will have all of the requisites to build the tests and run the suite of tests.

### Running the Test Suite Locally

The test suite is meant to be built and executed fully within the Docker environment.

#### Retreive the Latest Source Code

Testers will want to ensure they have the most up-to-date files from the Gitub repository.

#### Building and Running the Docker Container

Testers will need to build a version of the Docker container that matches which web browser they wish to execute tests under.

In order to build the Chrome test suite, run the following command on MacOS and Linux:

```console
cd /QA_tests/spec/convocate/selenium/chrome

docker run -e "BaseURL={{BaseURL}}" -it $(docker build -q .)
```

### Expected Output

You should receive output from the script similar to the following if all tests pass:

```console
test_check_About_link (__main__.Convocate_Tests) ... Page Title Is: The Center for Civil and Human Rights | Convocate
ok
test_check_Banner (__main__.Convocate_Tests) ... Page Title Is: University of Notre Dame
ok
test_check_Contact_link (__main__.Convocate_Tests) ... Page Title Is: The Center for Civil and Human Rights | Convocate
ok
test_check_HowToUse_link (__main__.Convocate_Tests) ... Page Title Is: The Center for Civil and Human Rights | Convocate
ok
test_check_Index_link (__main__.Convocate_Tests) ... Page Title Is: The Center for Civil and Human Rights | Convocate
ok
test_check_Partners_link (__main__.Convocate_Tests) ... Page Title Is: The Center for Civil and Human Rights | Convocate
ok
test_homepage (__main__.Convocate_Tests) ... Page Title is: The Center for Civil and Human Rights | Convocate
ok

----------------------------------------------------------------------
Ran 7 tests in ${TIME}s

OK
```

If the any of the tests fail, you can expect output similar to the following:

```console
test_check_News_link (__main__.Convocate_Tests) ... ERROR
======================================================================
ERROR: test_check_News_link (__main__.Convocate_Tests)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/etc/selenium/spec/convocate_selenium_chrome_homepage.py", line 38, in test_check_News_link
    news = driver.find_element_by_link_text("News")
  File "/usr/local/lib/python3.6/dist-packages/selenium/webdriver/remote/webdriver.py", line 428, in find_element_by_link_text
    return self.find_element(by=By.LINK_TEXT, value=link_text)
  File "/usr/local/lib/python3.6/dist-packages/selenium/webdriver/remote/webdriver.py", line 978, in find_element
    'value': value})['value']
  File "/usr/local/lib/python3.6/dist-packages/selenium/webdriver/remote/webdriver.py", line 321, in execute
    self.error_handler.check_response(response)
  File "/usr/local/lib/python3.6/dist-packages/selenium/webdriver/remote/errorhandler.py", line 242, in check_response
    raise exception_class(message, screen, stacktrace)
selenium.common.exceptions.NoSuchElementException: Message: no such element: Unable to locate element: {"method":"link text","selector":"News"}
  (Session info: headless chrome=74.0.3729.108)
  (Driver info: chromedriver=74.0.3729.6 (255758eccf3d244491b8a1317aa76e1ce10d57e9-refs/branch-heads/3729@{#29}),platform=Linux 4.9.184-linuxkit x86_64)
```
