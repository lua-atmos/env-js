#!/bin/bash
set -euo pipefail

MODE=""
VERSION=""
while [[ "${1:-}" == --* ]]; do
    case "$1" in
        --mode=*)    MODE="${1#--mode=}" ; shift ;;
        --version=*) VERSION="${1#--version=}" ; shift ;;
        *)           echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [ -z "$MODE" ] || [ -z "$VERSION" ]; then
    echo "Usage: run.sh --version=VERSION --mode=lua|lua-atmos|atmos FILE"
    exit 1
fi

FILE="${1:?Usage: run.sh --version=VERSION --mode=lua|lua-atmos|atmos FILE}"
DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="$DIR/out/$VERSION/$MODE.html"

if [ ! -f "$HTML" ]; then
    echo "No such runner: $HTML"
    echo "Run 'bash build-$VERSION.sh' first."
    exit 1
fi

CODE=$(base64 -w0 < "$FILE")
echo "URL: file://$HTML#$CODE"
xdg-open "file://$HTML#$CODE" 2>/dev/null ||
open "file://$HTML#$CODE" 2>/dev/null
