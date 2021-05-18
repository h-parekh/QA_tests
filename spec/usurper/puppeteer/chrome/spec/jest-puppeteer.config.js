module.exports = {
    launch: {
        headless: process.env.HEADLESS !== 'true',
        slowMo: process.env.SLOWMO ? process.env.SLOWMO : 0,
        devtools: true
    }
}