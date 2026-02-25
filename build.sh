# Shared build logic for lua-atmos HTML generation.
# Expects caller to define: VERSIONS, LUA_ATMOS_MODULES,
# ATMOS_LANG_MODULES.

GITHUB_RAW="https://raw.githubusercontent.com"

# --- Helpers ---

module_tag () {
    local name="$1" repo="$2" version="$3" path="$4"
    local url="$GITHUB_RAW/$repo/$version/$path"
    printf '    <script type="text/lua" data-module="%s" src="%s"></script>\n' "$name" "$url"
}

generate_html () {
    local title="$1" module_tags="$2" js_files="$3" out="$4"

    local base="${out%.html}"
    local vout="${base}-${VERSIONS[overall]}.html"

    local js_code="// lua-atmos ${VERSIONS[overall]}"$'\n'
    for f in $js_files; do
        js_code+="$(cat "$f")"$'\n'
    done

    cat > "$vout" <<ENDHTML
<!DOCTYPE html>
<html>
<head><title>$title</title></head>
<body>
    <span id="status"></span>
    <pre id="output"></pre>

$module_tags
    <script type="module">
$js_code
    </script>
</body>
</html>
ENDHTML
    echo "  wrote $vout"
}

# --- Build module tags ---

RUNTIME_TAGS=""
for entry in "${LUA_ATMOS_MODULES[@]}"; do
    read -r name repo version path <<< "$entry"
    RUNTIME_TAGS+="$(module_tag "$name" "$repo" "$version" "$path")"$'\n'
done

COMPILER_TAGS=""
for entry in "${ATMOS_LANG_MODULES[@]}"; do
    read -r name repo version path <<< "$entry"
    COMPILER_TAGS+="$(module_tag "$name" "$repo" "$version" "$path")"$'\n'
done

# --- Generate HTML files ---

echo "Generating HTML files..."

generate_html \
    "Lua" \
    "" \
    "./run.js ./lua.js" \
    "./lua.html"

generate_html \
    "lua-atmos" \
    "$RUNTIME_TAGS" \
    "./run.js ./lua-atmos.js" \
    "./lua-atmos.html"

generate_html \
    "Atmos" \
    "${RUNTIME_TAGS}${COMPILER_TAGS}" \
    "./run.js ./atmos.js" \
    "./atmos.html"

echo "Done."
