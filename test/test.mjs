import assert from 'node:assert/strict';
import http from 'node:http';
import fs from 'node:fs';
import { fileURLToPath } from 'node:url';
import { resolve, dirname, extname } from 'node:path';
import puppeteer from 'puppeteer';

const __dirname = dirname(fileURLToPath(import.meta.url));
const HTML_DIR = resolve(__dirname, '..');

const TIERS = ['lua.html', 'lua-atmos.html', 'atmos.html'];
const LOADING = ['Loading...', 'Running...', 'Compiling...'];
const TIMEOUT = 30_000;
const POLL = 100;

const MIME = {
    '.html': 'text/html',
    '.js':   'application/javascript',
    '.lua':  'text/plain',
};

function startServer () {
    return new Promise(ok => {
        const srv = http.createServer((req, res) => {
            const filePath = resolve(HTML_DIR, req.url.slice(1));
            const ext = extname(filePath);
            res.setHeader('Content-Type', MIME[ext] || 'application/octet-stream');
            fs.createReadStream(filePath)
                .on('error', () => { res.writeHead(404); res.end(); })
                .pipe(res);
        });
        srv.listen(0, '127.0.0.1', () => ok(srv));
    });
}

function pageUrl (server, name, code) {
    const { port } = server.address();
    const hash = Buffer.from(code).toString('base64');
    return `http://127.0.0.1:${port}/${name}#${hash}`;
}

async function waitStatus (page) {
    const t0 = Date.now();
    while (Date.now() - t0 < TIMEOUT) {
        const txt = await page.$eval(
            '#status', el => el.textContent
        );
        if (!LOADING.includes(txt)) return txt;
        await new Promise(r => setTimeout(r, POLL));
    }
    throw new Error('timeout waiting for status');
}

async function run () {
    const server = await startServer();

    const browser = await puppeteer.launch({
        headless: true,
        args: ['--no-sandbox'],
    });

    let failed = false;

    for (const tier of TIERS) {
        // Happy path
        const page1 = await browser.newPage();
        const url1 = pageUrl(server, tier, 'print("hello")');
        await page1.goto(url1, {
            waitUntil: 'domcontentloaded',
        });
        const st1 = await waitStatus(page1);
        const out1 = await page1.$eval(
            '#output', el => el.textContent
        );
        try {
            assert.equal(st1, 'Done.',
                tier + ' happy: status');
            assert.equal(out1, 'hello\n',
                tier + ' happy: output');
            console.log('PASS', tier, 'happy');
        } catch (e) {
            console.error('FAIL', tier, 'happy:', e.message);
            failed = true;
        }
        await page1.close();

        // Error path
        const page2 = await browser.newPage();
        const url2 = pageUrl(server, tier, 'invalid!!!lua');
        await page2.goto(url2, {
            waitUntil: 'domcontentloaded',
        });
        const st2 = await waitStatus(page2);
        const out2 = await page2.$eval(
            '#output', el => el.textContent
        );
        try {
            assert.equal(st2, 'Error.',
                tier + ' error: status');
            assert.ok(out2.includes('ERROR'),
                tier + ' error: output contains ERROR');
            console.log('PASS', tier, 'error');
        } catch (e) {
            console.error('FAIL', tier, 'error:', e.message);
            failed = true;
        }
        await page2.close();
    }

    await browser.close();
    server.close();
    if (failed) process.exit(1);
}

run();
