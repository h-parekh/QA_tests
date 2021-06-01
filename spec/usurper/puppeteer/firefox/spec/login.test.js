const puppeteer = require('puppeteer');

const username = process.env.TEST_USERNAME;
const passphrase = process.env.TEST_PASSWORD;
const url = process.env.BaseURL;

describe('Website End to End Tests', () => {

  let browser;
  let page;

  beforeAll( async () => {
    browser = await puppeteer.launch({
      product: 'firefox'
    });
    await browser
  })
  beforeEach( async () => {
    page = await browser.newPage();
    jest.setTimeout(15000);
  });
  // Close the headless browser after all tests, regardless of outcome

  afterAll( async () => {
    await browser.close()
  });

    describe('Website Returns Expected Content', () => {
      test('Page Title contains Hesburgh', async () => {
        await page.goto(url, {waitUntil: 'domcontentloaded'});
        const pageTitle = await page.title();
        expect(pageTitle).toContain('Hesburgh');
      })
      test('Page has working login button', async () => {
        await page.goto(url);
        await page.waitForSelector('.uNavigation > .container-fluid > .menu-list > .user > .m');
        await page.$eval('.uNavigation > .container-fluid > .menu-list > .user > .m', el => el.click(), );
        await page.waitForSelector('.o-form-fieldset-container #okta-signin-username');
        const pageTitle = await page.title();
        expect(pageTitle).toContain('Sign In')
      })
  })

    describe('Login End-to-End Tests', () => {
      beforeEach(() => {
        jest.setTimeout(30000)
      });
      test('Valid users are logged in', async () => {
        await page.goto(url, {waitUntil: 'domcontentloaded'});
        await page.waitForSelector('.uNavigation > .container-fluid > .menu-list > .user > .m');
        await page.$eval('.uNavigation > .container-fluid > .menu-list > .user > .m', el => el.click(), {waitUntil: 'networkidle0'});
        const signinField = await page.waitForSelector('.o-form-fieldset-container #okta-signin-username');
        await signinField.type(username, {delay: 100});
        const passwordField = ('.o-form-fieldset-container #okta-signin-password');
        await page.type(passwordField, passphrase, {delay: 100});
        await page.click('#okta-signin-submit.button.button-primary');
        await page.waitForSelector('.uNavigation > .container-fluid > .menu-list > .user > .m', {waitUntil: 'networkidle0'});
        const pageTitle = await page.title();
        expect(pageTitle).toContain('Hesburgh')
      })
    })
})
