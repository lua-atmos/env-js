#!/bin/bash
set -euo pipefail

MODE=""
while [[ "${1:-}" == --* ]]; do
    case "$1" in
        --mode=*) MODE="${1#--mode=}" ; shift ;;
        *)        echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [ -z "$MODE" ]; then
    echo "Usage: run.sh --mode=lua|lua-atmos|atmos FILE"
    exit 1
fi

FILE="${1:?Usage: run.sh --mode=lua|lua-atmos|atmos FILE}"
DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="$DIR/$MODE.html"

if [ ! -f "$HTML" ]; then
    echo "No such runner: $HTML"
    echo "Run 'bash build.sh' first."
    exit 1
fi

CODE=$(base64 -w0 < "$FILE")
echo "URL: file://$HTML#$CODE"
xdg-open "file://$HTML#$CODE" 2>/dev/null ||
open "file://$HTML#$CODE" 2>/dev/null
