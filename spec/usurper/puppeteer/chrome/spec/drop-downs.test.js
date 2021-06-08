const puppeteer = require('puppeteer')

const url = process.env.BaseURL

describe('Drop Down Menus', () => {
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
    afterAll( async () => {
      await browser.close()
    });

    test('Control Test', async () => {
        await page.goto(url, { waitUntil: 'networkidle0' })
        const pageTitle = await page.title()
        expect(pageTitle).toContain('Hesburgh')
    })

    test('Research Drop Down', async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#research");
            await page.$eval("#research", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#researchNav")
            const viewMore = await page.$eval('#researchNav', () => true).catch(() => false)
            expect(viewMore).toBe(true)
    })

    test('Services Drop Down', async () => {
        await page.goto(url, { waitUntil: 'networkidle0'})
        await page.waitForSelector('#services')
        await page.$eval('#services', el => el.click())
        await page.waitForSelector("#servicesNav");
        const viewMore = await page.$eval("#servicesNav", () => true).catch(() => false);
        expect(viewMore).toBe(true)
    })

    test('Libraries Drop Down', async () => {
      await page.goto(url, { waitUntil: 'networkidle0'})
      await page.waitForSelector('#libraries')
      await page.$eval('#libraries', el => el.click())
      await page.waitForSelector("#librariesNav");
      const viewMore = await page.$eval("#librariesNav", () => true).catch(() => false);
      expect(viewMore).toBe(true)
    })

    test('About Drop Down', async () => {
      await page.goto(url, { waitUntil: 'networkidle0'})
      await page.waitForSelector('#about')
      await page.$eval('#about', el => el.click())
      await page.waitForSelector("#aboutNav");
      const viewMore = await page.$eval("#aboutNav", () => true).catch(() => false);
      expect(viewMore).toBe(true)
    })

    test('Header Search Drop Down', async () => {
      await page.goto(url, { waitUntil: 'networkidle0'})
      await page.waitForSelector('#header-search-button')
      await page.$eval('#header-search-button', el => el.click())
      await page.waitForSelector("#root");
      const viewMore = await page.$eval("#basic-search-field", () => true).catch(() => false);
      expect(viewMore).toBe(false)
    })
})