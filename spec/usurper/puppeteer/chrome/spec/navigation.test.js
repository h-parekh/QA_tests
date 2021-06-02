const puppeteer = require('puppeteer')

const url = process.env.BaseURL;

//TODO: Get working helper function to adhere to DRY
async function navigationFunction(url, urlTextToCheck, selectorToClick, subSelectorToClick) {
    let browser = await puppeteer.launch({
        args: ["--disable-dev-shm-usage"],
        headless: false
      });
    let page = await browser.newPage();
    jest.setTimeout(10000)
    await page.goto(url, { waitUntil: "networkidle0" });
    await page.waitForSelector(selectorToClick);
    await page.$eval(selectorToClick, (el) =>
      el.click()
    );
    await page, { waitUntil: "networkidle0" };
    await page.waitForSelector(subSelectorToClick);
    await page.$eval(subSelectorToClick, (el) =>
      el.click()
    );
    const pageURL = await page.url();
    expect(pageURL).toContain(urlTextToCheck);
    page.close()
}

describe("Website Navigation Checks", () => {
    let browser;
    let page;

    beforeAll(async () => {
        browser = await puppeteer.launch({
          args: ["--disable-dev-shm-usage"],
          headless: true,
          defaultViewport: null
        });
      });

    beforeEach(async () => {
        page = await browser.newPage();
        jest.setTimeout(20000);
      });
    
    afterEach(async () => {
    await page.close();
    });
    // Close the headless browser after all tests, regardless of outcome

    afterAll(async () => {
    await browser.close();
    });

    test("Main Page Loads", async () => {
        await page.goto(url, { waitUntil: "networkidle0" })
        const pageURL = await page.url()
        expect(pageURL).toContain(url)
    });

    describe("Research Links", () => {

        test("Databases -> Database Page", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#research");
            await page.$eval("#research", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#researchNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(1) > a");
            await page.$eval("#researchNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(1) > a", (el) =>
            el.click()
            );
            const pageURL = await page.url();
            expect(pageURL).toContain("databases");
        });

        test("View More Research -> Research", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#research");
            await page.$eval("#research", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#researchNav > div:nth-child(2) > div > a > div");
            await page.$eval("#researchNav > div:nth-child(2) > div > a > div", (el) =>
            el.click()
            );
            const pageURL = await page.url();
            expect(pageURL).toContain("research");
        });

        test("Library Guides -> LibGuides", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#research");
            await page.$eval("#research", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#researchNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(4) > a");
            await page.$eval("#researchNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(4) > a", (el) =>
            el.click()
            );
            const [newTab] = await Promise.all([
                new Promise( resolve => browser.once('targetcreated', resolve)),
            ])
            const pageURL = await newTab.url();
            expect(pageURL).toContain("libguides");

        });

        test("CurateND", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#research");
            await page.$eval("#research", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#researchNav > div:nth-child(1) > div:nth-child(2) > ul > li:nth-child(6) > a");
            await page.$eval("#researchNav > div:nth-child(1) > div:nth-child(2) > ul > li:nth-child(6) > a", (el) =>
            el.click()
            );
            const [newTab] = await Promise.all([
                new Promise( resolve => browser.once('targetcreated', resolve)),
            ])
            const pageURL = await newTab.url();
            expect(pageURL).toContain("curate.nd.edu");
        });

        test("JSTOR", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#research");
            await page.$eval("#research", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#researchNav > div:nth-child(1) > div:nth-child(3) > ul > li:nth-child(2) > a");
            // Here, we want to be sure that the destination link is right. However, navigating it is tricky due to auth
            // requirements, so we'll just look at the destination and allow login.test.js to ensure logins aren't broken.
            const pageURL = await page.$eval("#researchNav > div:nth-child(1) > div:nth-child(3) > ul > li:nth-child(2) > a", (el) => el.href);
            expect(pageURL).toContain("databases/jstor");

        });
    })

    describe("Services Links", () => {

        test("Find a Study Space -> Study Spaces", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#services");
            await page.$eval("#services", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#servicesNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(1) > a");
            await page.$eval("#servicesNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(1) > a", (el) =>
            el.click()
            );
            const pageURL = await page.url();
            expect(pageURL).toContain("study-spaces");
        });

        test("ILL and DocDel", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#services");
            await page.$eval("#services", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#servicesNav > div:nth-child(1) > div:nth-child(2) > ul > li:nth-child(2) > a");
            const pageURL = await page.$eval("#servicesNav > div:nth-child(1) > div:nth-child(2) > ul > li:nth-child(2) > a", (el) =>
            el.href
            );
            expect(pageURL).toContain("illiad");
        });

        test("View More Services -> Services", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#services");
            await page.$eval("#services", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#servicesNav > div:nth-child(2) > div > a");
            await page.$eval("#servicesNav > div:nth-child(2) > div > a", (el) =>
            el.click()
            );
            const pageURL = await page.url();
            expect(pageURL).toContain("services");
        });
    })

    describe("Libraries Links", () => {
        test("Rare Books and Special Collections", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#libraries");
            await page.$eval("#libraries", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#librariesNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(7) > a");
            await page.$eval("#librariesNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(7) > a", (el) =>
            el.click()
            );
            const [newTab] = await Promise.all([
                new Promise( resolve => browser.once('targetcreated', resolve)),
            ])
            const pageURL = await newTab.url();
            expect(pageURL).toContain("rarebooks");
        });
    })

    describe("About Links", () => {
        test("Directory", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#about");
            await page.$eval("#about", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#aboutNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(2) > a");
            const pageURL = await page.$eval("#aboutNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(2) > a", (el) =>
            el.href
            );
            expect(pageURL).toContain("directory.library.nd.edu/directory");
        });

        test("About -> Employment", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#about");
            await page.$eval("#about", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#aboutNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(3) > a");
            await page.$eval("#aboutNav > div:nth-child(1) > div.col-md-offset-2.col-md-3 > ul > li:nth-child(3) > a", (el) =>
            el.click()
            );
            const pageURL = await page.url();
            expect(pageURL).toContain("employment");
        });
    })

    describe("Hours", () => {
        test("Hours", async () => {
            await page.goto(url, { waitUntil: "networkidle0" });
            await page.waitForSelector("#banner > hgroup.nav-search > div > nav > ul > li.menu-link.hours-m.right > a");
            await page.$eval("#banner > hgroup.nav-search > div > nav > ul > li.menu-link.hours-m.right > a", (el) =>
            el.click()
            );
            await page, { waitUntil: "networkidle0" };
            await page.waitForSelector("#main-page-title")
            const pageURL = await page.url();
            expect(pageURL).toContain("hours");
        });
    })
})