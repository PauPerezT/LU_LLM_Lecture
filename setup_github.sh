#!/usr/bin/env bash
# Publish this folder to GitHub and turn on Pages.
#
#   ./setup_github.sh <github-user>/<repository>  [public|private]
#
# Needs the GitHub CLI, signed in:  gh auth login
set -euo pipefail

REPO="${1:-}"
VIS="${2:-public}"
if [[ -z "$REPO" || "$REPO" != */* ]]; then
  echo "usage: ./setup_github.sh <user>/<repo> [public|private]" >&2
  exit 1
fi

command -v gh >/dev/null || { echo "GitHub CLI not found. See https://cli.github.com" >&2; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Not signed in. Run:  gh auth login" >&2; exit 1; }

# 1. point the page's buttons at this repository
python3 - "$REPO" <<'PY'
import re, sys, pathlib
repo = sys.argv[1]
p = pathlib.Path("docs/index.html")
s = p.read_text(encoding="utf-8")
s2 = re.sub(r'const REPO\s*=\s*"[^"]*";', 'const REPO   = "%s";' % repo, s, count=1)
p.write_text(s2, encoding="utf-8")
print("   docs/index.html -> REPO =", repo)
PY

# 2. commit
[[ -d .git ]] || git init -q -b main
git add -A
git commit -qm "Self-Attention Explorer and student exercise" || echo "   nothing new to commit"

# 3. create (or reuse) the repository and push
if gh repo view "$REPO" >/dev/null 2>&1; then
  echo "   repository exists - pushing to it"
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$REPO.git"
  git push -u origin main
else
  gh repo create "$REPO" --"$VIS" --source=. --remote=origin --push
fi

# 4. GitHub Pages, from /docs on main
echo "   enabling Pages (main / docs)..."
gh api -X POST "repos/$REPO/pages" \
  -f "source[branch]=main" -f "source[path]=/docs" >/dev/null 2>&1 \
  || gh api -X PUT "repos/$REPO/pages" \
       -f "source[branch]=main" -f "source[path]=/docs" >/dev/null 2>&1 \
  || echo "   could not set Pages via the API - do it in Settings > Pages (main, /docs)"

USER="${REPO%%/*}"; NAME="${REPO##*/}"
echo
echo "Done."
echo "  repository : https://github.com/$REPO"
echo "  page       : https://$USER.github.io/$NAME/   (first build takes a minute)"
