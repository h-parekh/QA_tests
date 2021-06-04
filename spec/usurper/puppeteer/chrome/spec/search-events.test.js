const puppeteer = require('puppeteer')

const url = process.env.BaseURL
const searchTerm = 'Library'

describe('Search Events', () => {
    let browser;
    let page;
  
    beforeAll( async () => {
      browser = await puppeteer.launch({
        args: ['--disable-dev-shm-usage'],
      });
    })
    beforeEach( async () => {
      page = await browser.newPage();
      jest.setTimeout(50000);
    });
    // Close the headless browser after all tests, regardless of outcome
  
    afterAll( async () => {
      await browser.close()
    });

    test('Control Test', async () => {
        await page.goto(url, { waitUntil: 'networkidle0' })
        const pageTitle = await page.title()
        expect(pageTitle).toContain('Hesburgh')
    })

    test('Current Events Search Returns', async () => {
        await page.goto(url, { waitUntil: 'networkidle0'})
        await page.waitForSelector('#root > div > div.Home.main > div:nth-child(6) > div > div.col-md-4.col-xs-12 > section > a.newsEventHeader')
        await page.$eval('#root > div > div.Home.main > div:nth-child(6) > div > div.col-md-4.col-xs-12 > section > a.newsEventHeader', el => el.click())
        await page.waitForSelector('#maincontent > div > div > div.col-md-8.col-sm-7.col-xs-12.landing-page-list.events-list > div.style_filter__O5asF > label > input[type=search]', { waitUntil: 'networkidle0'})
        const searchBox = '#maincontent > div > div > div.col-md-8.col-sm-7.col-xs-12.landing-page-list.events-list > div.style_filter__O5asF > label > input[type=search]'
        await page.type(searchBox, searchTerm, {delay: 100})
        await page.waitForSelector('#main-page-title')
        const loadedTitle = await page.$eval('#main-page-title', el => el.innerText)
        expect(loadedTitle).toContain(searchTerm)
    })

    test('Past Events Search Returns', async () => {
        await page.goto(url, { waitUntil: 'networkidle0'})
        await page.waitForSelector('#root > div > div.Home.main > div:nth-child(6) > div > div.col-md-4.col-xs-12 > section > a.newsEventHeader')
        await page.$eval('#root > div > div.Home.main > div:nth-child(6) > div > div.col-md-4.col-xs-12 > section > a.newsEventHeader', el => el.click())
        await page.waitForSelector('#maincontent > div > a')
        await page.$eval('#maincontent > div > a', el => el.click())
        const searchBox = '#maincontent > div > div > div.col-md-8.col-sm-7.col-xs-12.landing-page-list.events-list > div.style_filter__O5asF > label > input[type=search]'
        await page.type(searchBox, searchTerm, {delay: 100})
        await page.waitForSelector('#main-page-title')
        const loadedTitle = await page.$eval('#main-page-title', el => el.innerText)
        expect(loadedTitle).toContain(searchTerm)
        const archive = await page.$eval('#maincontent > div > div > div.col-md-4.col-sm-5.col-xs-12.right.landing-page-sidebar.events-sidebar > aside.style_dateFilter__1C881 > div > span', el => el.innerText)
        expect(archive).toContain('Archive')
    })
})