# env-js

Browser-based runners for Lua and Atmos programs. Source code is passed as a base64 hash in the URL fragment.

## HTML files

| File | Input language | Runtime |
|------|---|---|
| `lua.html` | Lua | bare Lua |
| `lua-atmos.html` | Lua | lua-atmos |
| `atmos.html` | Atmos (`.atm`) | lua-atmos + compiler |

## Local Usage

```
./run.sh --mode=lua exs/hello.lua               # bare Lua
./run.sh --mode=lua-atmos exs/hello-atmos.lua   # lua-atmos
./run.sh --mode=atmos exs/hello.atm             # atmos-lang
```

Opens the program in your default browser.

## Remote Usage

Open any HTML file with a `#<base64>` fragment:

```
lua.html#cHJpbnQoImhlbGxvIik=
```

The fragment is the base64-encoded source code. Status goes to `<span id="status">`; output goes to `<pre id="output">`.

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
file:///path/to/lua.html#cHJpbnQoImhlbGxvIik=
```

## Rebuilding

```
./build.sh
```

Fetches all runtime and compiler modules from GitHub and regenerates the three HTML files.
