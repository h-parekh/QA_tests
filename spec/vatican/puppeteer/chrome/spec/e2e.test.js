const puppeteer = require("puppeteer");
const url = process.env.BaseURL;

describe("Convocate End to End Tests", () => {
  let browser;
  let page;

  beforeAll(async () => {
    browser = await puppeteer.launch({
      args: ["--disable-dev-shm-usage"],
    });
  });

  //Run each test on its own page with a default timeout of 10s
  beforeEach(async () => {
    page = await browser.newPage();
    jest.setTimeout(10000);
  });

  //After a successful test, close each page to cut down on resource utilization
  afterEach(async () => {
    await page.close();
  });
  // Close the headless browser after all tests, regardless of outcome

  afterAll(async () => {
    await browser.close();
  });

  describe("Website Returns Expected Content", () => {
    test("Page Title contains Convocate", async () => {
      await page.goto(url, { waitUntil: "networkidle0" });
      const pageTitle = await page.title();
      expect(pageTitle).toContain("Convocate");
    });
    test("Page has working Search Link", async () => {
      await page.goto(url, { waitUntil: "networkidle0" });
      await page.waitForSelector(
        "#content > div > div > div > section > h2 > a"
      );
      await page.$eval("#content > div > div > div > section > h2 > a", (el) =>
        el.click()
      );
      await page, { waitUntil: "networkidle0" };
      const pageURL = await page.url();
      expect(pageURL).toContain("search");
    });
    test("Page has working Instruction Link", async () => {
      await page.goto(url, { waitUntil: "networkidle0" });
      await page.waitForSelector(
        "#content > div > div > div > nav > ul.contentnav > li:nth-child(1) > a"
      );
      await page.$eval(
        "#content > div > div > div > nav > ul.contentnav > li:nth-child(1) > a",
        (el) => el.click()
      );
      await page, { waitUntil: "networkidle0" };
      const pageURL = await page.url();
      expect(pageURL).toContain("how-to-use");
    });
    test("Page has working Index of Documents link", async () => {
      await page.goto(url, { waitUntil: "networkidle0" });
      await page.$eval(
        "#content > div > div > div > nav > ul.contentnav > li:nth-child(2) > a",
        (el) => el.click()
      );
      await page, { waitUntil: "networkidle0" };
      const pageURL = await page.url();
      expect(pageURL).toContain("documents");
    });
  });

  describe("Search End-to-End Tests", () => {
    test('Boxes can be checked in "Search By Topic"', async () => {
      const textToContain = "Catholic Social Teaching";
      await page.goto(url, { waitUntil: "networkidle0" });
      await page.$eval("#content > div > div > div > section > h2 > a", (el) =>
        el.click()
      );
      await page.waitForSelector(
        "#content > div > div > div > div.row.body > div > div.col-sm-3.left-col > div > ul > ul > li:nth-child(1) > div > div:nth-child(1) > i"
      );
      await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-3.left-col > div > ul > ul > li:nth-child(1) > div > div:nth-child(1) > i",
        (el) => el.click()
      );
      const result = await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div:nth-child(4) > div > h3",
        (el) => el.textContent.trim()
      );
      expect(result).toContain(textToContain);
    });
    test("Clearing the Selected Topic works", async () => {
      const textToContain = "Getting started";
      await page.goto(url, { waitUntil: "networkidle0" });
      await page.$eval("#content > div > div > div > section > h2 > a", (el) =>
        el.click()
      );
      await page.waitForSelector(
        "#content > div > div > div > div.row.body > div > div.col-sm-3.left-col > div > ul > ul > li:nth-child(1) > div > div:nth-child(1) > i"
      );
      await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-3.left-col > div > ul > ul > li:nth-child(1) > div > div:nth-child(1) > i",
        (el) => el.click()
      );
      await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-3.left-col > div > div:nth-child(1) > button > div > span",
        (el) => el.click()
      );
      const result = await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col",
        (el) => el.textContent.trim()
      );
      expect(result).toContain(textToContain);
    });
    test("Search results are divided into columns", async () => {
      const columnOneText = "Catholic Social Teaching";
      const columnTwoText = "International Human Rights Law";
      await page.goto(url, { waitUntil: "networkidle0" });
      await page.$eval("#content > div > div > div > section > h2 > a", (el) =>
        el.click()
      );
      await page.waitForSelector(
        "#content > div > div > div > div.row.body > div > div.col-sm-3.left-col > div > ul > ul > li:nth-child(1) > div > div:nth-child(1) > i"
      );
      await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-3.left-col > div > ul > ul > li:nth-child(1) > div > div:nth-child(1) > i",
        (el) => el.click()
      );
      const columnOneResult = await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div:nth-child(4)",
        (el) => el.textContent.trim()
      );
      const columnTwoResult = await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div:nth-child(5)",
        (el) => el.textContent.trim()
      );
      expect(columnOneResult).toContain(columnOneText);
      expect(columnTwoResult).toContain(columnTwoText);
    });
    test("Entire documents can be accessed", async () => {
      jest.setTimeout(30000); // In this test, we're going all the way to retrieving a document, which isn't particularly performant. Therfore, we need to up the timeout
      const textToContain = "Topics in Document";
      const textToSearch = "Vatican";
      await page.goto(url, { waitUntil: "networkidle0" });
      await page.$eval("#content > div > div > div > section > h2 > a", (el) =>
        el.click()
      );
      const inputBox = await page.waitForXPath('//*[@id="searchBox"]');
      await inputBox.type(textToSearch, { delay: 100 });
      await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div.col-sm-10 > div > div:nth-child(2) > div > button",
        (el) => el.click()
      );
      await page.waitForSelector(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div:nth-child(4) > div > div > div > article:nth-child(1) > a"
      );
      await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div:nth-child(4) > div > div > div > article:nth-child(1) > a",
        (el) => el.click()
      );
      await page.waitForSelector(
        "#content > div > div > div > div:nth-child(3) > div:nth-child(1) > div > div > div:nth-child(3) > h4"
      );
      const documentResult = await page.$eval(
        "#content > div > div > div > div:nth-child(3) > div:nth-child(1) > div > div > div:nth-child(3) > h4",
        (el) => el.textContent.trim()
      );
      expect(documentResult).toContain(textToContain);
    });

    test("Sorting functions work on results page", async () => {
      const columnOneText = "Catholic Social Teaching";
      const columnTwoText = "International Human Rights Law";
      const buttonText = "Date New-Old";
      await page.goto(url, { waitUntil: "networkidle0" });
      await page.$eval("#content > div > div > div > section > h2 > a", (el) =>
        el.click()
      );
      await page.waitForSelector(
        "#content > div > div > div > div.row.body > div > div.col-sm-3.left-col > div > ul > ul > li:nth-child(1) > div > div:nth-child(1) > i"
      );
      await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-3.left-col > div > ul > ul > li:nth-child(1) > div > div:nth-child(1) > i",
        (el) => el.click()
      );
      const columnOneResult = await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div:nth-child(4)",
        (el) => el.textContent.trim()
      );
      const columnTwoResult = await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div:nth-child(5)",
        (el) => el.textContent.trim()
      );
      //Verify that some results have been returned before we start to sort
      expect(columnOneResult).toContain(columnOneText);
      expect(columnTwoResult).toContain(columnTwoText);
      await page.waitForSelector(".col-sm-4 > .col-sm-12 > div > div > select");
      await page.click(".col-sm-4 > .col-sm-12 > div > div > select");
      await page.select(
        ".col-sm-4 > .col-sm-12 > div > div > select",
        "year_desc"
      );
      await page.click(".col-sm-4 > .col-sm-12 > div > div > select");
      const buttonResult = await page.$eval(
        ".col-sm-4 > .col-sm-12 > div > div > select",
        (el) => el.textContent.trim()
      );
      expect(buttonResult).toContain(buttonText);
      //Check again after the sort that our columns still exist as expected
      const columnOneResultPostSort = await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div:nth-child(4)",
        (el) => el.textContent.trim()
      );
      const columnTwoResultPostSort = await page.$eval(
        "#content > div > div > div > div.row.body > div > div.col-sm-4.right-col > div > div:nth-child(5)",
        (el) => el.textContent.trim()
      );
      expect(columnOneResultPostSort).toContain(columnOneText);
      expect(columnTwoResultPostSort).toContain(columnTwoText);
    });
  });
});
