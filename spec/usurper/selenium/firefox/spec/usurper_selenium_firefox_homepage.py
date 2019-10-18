import unittest
import os
import sys
import time
from selenium import webdriver
from selenium.webdriver import Firefox
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.support import expected_conditions as expected
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support.ui import WebDriverWait

BaseURL = os.environ.get('BaseURL')

class Usurper_Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):

    # def setUp(self):
        options = Options()
        options.add_argument('-headless')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--no-sandbox')
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

    def test_check_News_link(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        driver.find_element_by_xpath('/html/body/div[1]/div/div[2]/div/div[2]/div[1]/section/a[1]/h1').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "News | Hesburgh Libraries")

    def test_check_Events_link(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        driver.find_element_by_xpath('//*[@id="maincontent"]/div/div[2]/div[2]/section/a[1]/h1').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "Current Events | Hesburgh Libraries")

suite = unittest.TestLoader().loadTestsFromTestCase(Usurper_Tests)
result = unittest.TextTestRunner(verbosity=2).run(suite)
sys.exit(not result.wasSuccessful())
