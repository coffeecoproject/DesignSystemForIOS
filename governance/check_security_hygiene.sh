#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

SCAN_DIRS=(
  "Sources"
  "Tests"
  "Docs"
  "Examples"
  "governance"
  "README.md"
  "CHANGELOG.md"
  "CONTRIBUTING.md"
  "SECURITY.md"
)

secret_pattern='AKIA[0-9A-Z]{16}|-----BEGIN( RSA)? PRIVATE KEY-----|(?i)(api[_-]?key|secret|password)\s*[:=]\s*["'\''][^"'\'']+["'\'']|(?i)authorization:\s*bearer\s+[A-Za-z0-9._-]+'
secrets="$(rg -n "$secret_pattern" "${SCAN_DIRS[@]}" \
  --glob '!governance/check_security_hygiene.sh' || true)"
if [[ -n "$secrets" ]]; then
  echo "[security] potential secret detected:"
  echo "$secrets"
  exit 1
fi

private_endpoint_pattern='localhost|127\.0\.0\.1|192\.168\.[0-9]+\.[0-9]+|10\.[0-9]+\.[0-9]+\.[0-9]+|172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]+\.[0-9]+'
private_endpoints="$(rg -n "$private_endpoint_pattern" "${SCAN_DIRS[@]}" \
  --glob '!governance/check_security_hygiene.sh' || true)"
if [[ -n "$private_endpoints" ]]; then
  echo "[security] private/internal endpoint detected:"
  echo "$private_endpoints"
  exit 1
fi

dependency_lines="$(rg -n '^\s*\.package\(' Package.swift || true)"
if [[ -n "$dependency_lines" ]]; then
  allowlist_file="governance/dependency_allowlist.txt"
  if [[ ! -f "$allowlist_file" ]]; then
    echo "[security] package dependencies found but allowlist missing: $allowlist_file"
    echo "$dependency_lines"
    exit 1
  fi
fi

echo "[security] security and privacy hygiene checks passed."
