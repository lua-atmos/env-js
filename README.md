# env-js

Browser-based runners for Lua and Atmos programs.
Source code is passed as a base64 hash in the URL fragment.

## Versions

Each version has its own set of HTML files under `out/<version>/`.
The version determines which release of the Lua and Atmos
runtimes are fetched during the build.

Available versions:

| Version | Directory   | Description                   |
| ------- | ----------- | ----------------------------- |
| `main`  | `out/main/` | Latest development (unstable) |
| `v0.6`  | `out/v0.6/` | Atmos v0.6 release (stable)   |

## HTML files

Each version contains three HTML tiers:

| Path                   | Input language | Runtime              |
| ---------------------- | -------------- | -------------------- |
| `<ver>/lua.html`       | Lua            | bare Lua             |
| `<ver>/lua-atmos.html` | Lua            | lua-atmos            |
| `<ver>/atmos.html`     | Atmos (`.atm`) | lua-atmos + compiler |

## Local Usage

```
./run.sh --version=main --mode=lua exs/hello.lua
./run.sh --version=main --mode=lua-atmos exs/hello-atmos.lua
./run.sh --version=main --mode=atmos exs/hello.atm
```

Opens the program in your default browser.

## Remote Usage

Open any HTML file with a `#<base64>` fragment:

```
https://<url>/out/main/lua.html#cHJpbnQoImhlbGxvIik=
```

The fragment is the base64-encoded source code.
Status goes to `<span id="status">`;
output goes to `<pre id="output">`.

For `dev.ceu-lang.org`, we renamed `out` to `env-js`:

```
https://www.dev.ceu-lang.org/env-js/main/lua.html#cHJpbnQoImhlbGxvIik=
```

### Generating a hash

From a source file (`.lua` or `.atm`):

```
base64 -w0 < exs/hello.lua
```

Or inline:

```
echo -n 'print("hello")' | base64 -w0
```

Append the result after `#` in the URL:

```
file:///<env-js>/out/main/lua.html#cHJpbnQoImhlbGxvIik=
```

## Rebuilding

```
./build-main.sh
```

Fetches all runtime and compiler modules from GitHub and
regenerates the three HTML files.

## Testing

### Local

```
cd test && npm ci && npm test
```

Runs Puppeteer (headless Chrome) against all HTML tiers in
`out/main/` and `out/v0.6/`.
Each tier runs two scenarios: a happy path (`print("hello")`)
and an error path (invalid syntax).

### CI/CD

GitHub Actions (`.github/workflows/test.yml`) runs on every
push and PR to `main`:

| Job       | What it does                                   |
| --------- | ---------------------------------------------- |
| `build`   | Rebuilds HTML, checks `out/` matches committed |
| `js-test` | Runs the Puppeteer tests with Node 22          |
