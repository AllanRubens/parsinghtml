#!/usr/bin/env bash

set -euo pipefail

URL="$1"

if [[ -z "${URL:-}" ]]; then
    echo "uso: $0 https://site.com"
    exit 1
fi

# extrai domínio base
DOMAIN=$(echo "$URL" | sed -E 's#https?://([^/]+).*#\1#' | sed 's/^www\.//')

# baixa html
HTML=$(curl -Ls "$URL")

echo "$HTML" \
| grep -oiE 'href="[^"#]+"' \
| sed -E 's/href="(.*)"/\1/' \
| grep -E '^https?://' \
| sed -E 's#https?://([^/]+).*#\1#' \
| sed 's/^www\.//' \
| sort -u \
| grep "\.$DOMAIN$" \
| grep -v "^$DOMAIN$"
