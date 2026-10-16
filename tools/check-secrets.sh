#!/usr/bin/env bash
# Scan the repo for things that should never be pushed. Run before every git push.
cd "$(git rev-parse --show-toplevel)" || exit 1

patterns='discord(app)?\.com/api/webhooks|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|tskey-|api[_-]?key|client_secret|refresh_token|access_token|password\s*='

hits=$(git ls-files -co --exclude-standard | xargs grep -nIEi "$patterns" 2>/dev/null | grep -v 'tools/check-secrets.sh')

if [ -n "$hits" ]; then
  echo "Possible secrets found:"
  echo "$hits"
  exit 1
fi
echo "No obvious secrets found."
