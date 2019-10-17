import unittest
import os
import sys
import time
import tempfile
from selenium import webdriver
from selenium.webdriver import Firefox
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.support import expected_conditions as expected
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support.ui import WebDriverWait

# Custom profile folder to keep the minidump files
# profile = tempfile.mkdtemp(".selenium")
# print("*** Using profile: {}".format(profile))

BaseURL = os.environ.get('BaseURL')

class Usurper_Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):

    # def setUp(self):
        options = Options()
        options.add_argument("-headless")
        options.headless = True
        cls.driver = Firefox(options=options, log_path="/home/seluser/geckodriver.log")
        cls.driver.implicitly_wait(30)

    @classmethod
    def classTearDown(cls):
        cls.driver.quit()

    def test_homepage(self):
        driver = self.driver
        driver.implicitly_wait(30)
        driver.get("https://" + BaseURL)
        driver.find_element_by_xpath('//*[@id="maincontent"]/div/div[2]/div[1]/section/a[1]/h1') # This is in place to allow the browser window to properly wait until content is loaded before trying to assert the title
        print(''.join(['Page Title is: ',driver.title]))
        self.assertEqual(driver.title, "Hesburgh Libraries")

    def test_check_News_page(self):
        driver = self.driver
        driver.get("https://" + BaseURL + "/news")
        driver.find_element_by_xpath('//*[@id="main-page-title"]')
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "News | Hesburgh Libraries")

    def test_check_News_link(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        # Look for the News headers existence.
        try:
            news = WebDriverWait(driver, 10).until(expected.presence_of_element_located((By.XPATH, '/html/body/div[1]/div/div[2]/div/div[2]/div[1]/section/a[1]/h1')))
        # If you can't find it, throw an exception
        except:
            print("Could not find elements")
            BaseException.with_traceback
        # Regardless of if you find the element or not, run the assert so that the unit test passes or fails properly
        finally:
            print(''.join(['Page Title Is: ', driver.title]))
            self.assertEqual(driver.title, "Hesburgh Libraries")

    # def test_check_Events_link(self):
    #     events_driver = self.driver
    #     events_driver.implicitly_wait(30)
    #     events_driver.get("https://" + BaseURL)
    #     events = events_driver.find_element_by_xpath('//*[@id="maincontent"]/div/div[2]/div[2]/section/a[1]/h1')
    #     print(events_driver.title)
    #     events.click()
    #     print(''.join(['Page Title Is: ', events_driver.title]))
    #     self.assertEqual(events_driver.title, "Current and Upcoming Events | Hesburgh Libraries")
    #     print (events_driver.window_handles)


suite = unittest.TestLoader().loadTestsFromTestCase(Usurper_Tests)
result = unittest.TextTestRunner(verbosity=2).run(suite)
sys.exit(not result.wasSuccessful())
