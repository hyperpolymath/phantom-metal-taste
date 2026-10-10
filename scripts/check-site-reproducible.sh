#!/bin/sh
# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
set -eu

root=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' 0 HUP INT TERM

cd "$root"
bun scripts/build-site.mjs --config site.json --out "$tmp/first" > "$tmp/first.log"
bun scripts/build-site.mjs --config site.json --out "$tmp/second" > "$tmp/second.log"

grep -Eq 'sha256=[0-9a-f]{64}' "$tmp/first.log"
grep -Eq 'sha256=[0-9a-f]{64}' "$tmp/second.log"
diff -r "$tmp/first" "$tmp/second"
printf 'Site output is reproducible.\n'
