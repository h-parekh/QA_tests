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

# Custom profile folder to keep the minidump files
# profile = tempfile.mkdtemp(".selenium")
# print("*** Using profile: {}".format(profile))

BaseURL = os.environ.get('BaseURL')

class Usurper_Tests(unittest.TestCase):

    def setUp(self):
        options = Options()
        options.add_argument("-headless")
        # options.add_argument("-profile")
        # options.add_argument(profile)
        self.driver = Firefox(options=options, log_path="/home/seluser/geckodriver.log")

    def test_homepage(self):
        driver = self.driver
        driver.implicitly_wait(30)
        driver.get("https://" + BaseURL)
        driver.find_element_by_xpath('//*[@id="maincontent"]/div/div[2]/div[1]/section/a[1]/h1') # This is in place to allow the browser window to properly wait until content is loaded before trying to assert the title
        print(''.join(['Page Title is: ',driver.title]))
        self.assertEqual(driver.title, "Hesburgh Libraries")
        print (driver.window_handles)


    def test_check_News_link(self):
        news_driver = self.driver
        news_driver.implicitly_wait(30)
        news_driver.get("https://" + BaseURL)
        news = news_driver.find_element_by_css_selector('html body div#root div.home div#maincontent.container-fluid.content div.Home.main div.row.news div.col-md-6.col-xs-12 section a.newsEventHeader h1')
        print(news_driver.title)
        news.click()
        news_driver.find_element_by_xpath('//*[@id="main-page-title"]')
        # time.sleep(40)
        print(''.join(['Page Title Is: ', news_driver.title]))
        self.assertEqual(news_driver.title, "News | Hesburgh Libraries")
        print (news_driver.window_handles)


    def test_check_Events_link(self):
        events_driver = self.driver
        events_driver.implicitly_wait(30)
        events_driver.get("https://" + BaseURL)
        events = events_driver.find_element_by_xpath('//*[@id="maincontent"]/div/div[2]/div[2]/section/a[1]/h1')
        print(events_driver.title)
        events.click()
        print(''.join(['Page Title Is: ', events_driver.title]))
        self.assertEqual(events_driver.title, "Current and Upcoming Events | Hesburgh Libraries")
        print (events_driver.window_handles)


suite = unittest.TestLoader().loadTestsFromTestCase(Usurper_Tests)
result = unittest.TextTestRunner(verbosity=2).run(suite)
sys.exit(not result.wasSuccessful())
