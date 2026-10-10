#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0
# SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell <j.d.a.jewell@open.ac.uk>
#
# Fail if a tracked or unignored working-tree file uses the retired A2ML format.
set -euo pipefail

root="${1:-.}"
if [[ ! -d "$root" ]]; then
  printf 'ERROR: repository path does not exist: %s\n' "$root" >&2
  exit 2
fi

found=()
if git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  while IFS= read -r -d '' path; do
    case "$path" in
      *.a2ml|*.A2ML) found+=("$path") ;;
    esac
  done < <(git -C "$root" ls-files --cached --others --exclude-standard -z)
else
  while IFS= read -r -d '' path; do
    found+=("$path")
  done < <(find "$root" -path "$root/.git" -prune -o -type f \( -iname '*.a2ml' \) -print0)
fi

if ((${#found[@]})); then
  printf 'FAIL: A2ML is a retired format; migrate descriptive facts to the repo deed and contracts to current K9/Nickel files:\n' >&2
  printf '  %s\n' "${found[@]}" >&2
  exit 1
fi

printf 'PASS: no tracked or unignored A2ML files found\n'
