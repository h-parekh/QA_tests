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

class Convocate_Tests(unittest.TestCase):

    def setUp(self):
        options = Options()
        options.add_argument('-headless')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--no-sandbox')
        self.driver = Chrome(options=options)

    def test_homepage(self):
        driver = self.driver
        driver.implicitly_wait(10)
        driver.get("https://" + BaseURL)
        print(''.join(['Page Title is: ',driver.title]))
        self.assertEqual(driver.title, "The Center for Civil and Human Rights | Convocate")

    def test_check_Banner(self):
        driver = self.driver
        driver.implicitly_wait(10)
        driver.get("https://" + BaseURL)
        driver.find_element_by_xpath('//*[@id="header"]/h3').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "University of Notre Dame")

    def test_check_HowToUse_link(self):
        driver = self.driver
        driver.implicitly_wait(10)
        driver.get("https://" + BaseURL)
        driver.find_element_by_link_text('How To Use the Database').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "The Center for Civil and Human Rights | Convocate")

    def test_check_Index_link(self):
        driver = self.driver
        driver.implicitly_wait(10)
        driver.get("https://" + BaseURL)
        driver.find_element_by_link_text('Index of Documents').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "The Center for Civil and Human Rights | Convocate")

    def test_check_About_link(self):
        driver = self.driver
        driver.implicitly_wait(10)
        driver.get("https://" + BaseURL)
        driver.find_element_by_link_text('About the Database').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "The Center for Civil and Human Rights | Convocate")

    def test_check_Partners_link(self):
        driver = self.driver
        driver.implicitly_wait(10)
        driver.get("https://" + BaseURL)
        driver.find_element_by_link_text('Project Partners').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "The Center for Civil and Human Rights | Convocate")

    def test_check_Contact_link(self):
        driver = self.driver
        driver.implicitly_wait(10)
        driver.get("https://" + BaseURL)
        driver.find_element_by_link_text('Contact Us').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "The Center for Civil and Human Rights | Convocate")

suite = unittest.TestLoader().loadTestsFromTestCase(Convocate_Tests)
result = unittest.TextTestRunner(verbosity=2).run(suite)
sys.exit(not result.wasSuccessful())
