import unittest
import os
import sys
from selenium import webdriver
from selenium.webdriver import Chrome
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support import expected_conditions as expected
from selenium.webdriver.support.wait import WebDriverWait

BaseURL = os.environ.get('BaseURL')

class Usurper_Tests(unittest.TestCase):

    def setUp(self):
        options = Options()
        options.add_argument('-headless')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--no-sandbox')
        self.driver = Chrome(options=options)
        self.driver.implicitly_wait(10)


    def test_homepage(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        print(''.join(['Page Title is: ',driver.title]))
        self.assertEqual(driver.title, "Hesburgh Libraries")

    def test_check_News_link(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        news = driver.find_element_by_link_text("News").click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "News | Hesburgh Libraries")

    def test_check_Events_link(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        driver.find_element_by_link_text("Events").click()
        WebDriverWait(driver, 10).until(
            expected.presence_of_element_located((By.ID,"main-page-title"))
        )      
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "Current Events | Hesburgh Libraries")

suite = unittest.TestLoader().loadTestsFromTestCase(Usurper_Tests)
result = unittest.TextTestRunner(verbosity=2).run(suite)
sys.exit(not result.wasSuccessful())
