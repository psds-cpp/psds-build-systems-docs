#!/bin/sh
# check-listings.sh <NAME> [FIT]
#
# Mechanical check: every non-empty line of every file in
# presentations/<NAME>/src/ must be rendered on a SINGLE physical
# line of the pdftotext -layout dump of build/<NAME>.pdf.
# Minted's `breaklines` wraps long lines SILENTLY (no Overfull in
# the log), so this check is mandatory after every build.
#
# Usage (from the project root, inside nix develop):
#   nix develop --command pdftotext -layout build/<NAME>.pdf /tmp/opencode/fit.txt
#   nix develop --command sh .opencode/skills/luatex-presentation/scripts/check-listings.sh <NAME>
#
# Comparison is done after removing all whitespace from both the
# source line and each physical line of the dump (a physical line
# with a leading line-number margin is matched too).
#
# Output: one line per violating source line:  file:line: content
# Exit codes: 0 = no violations, 1 = violations found, 2 = usage error.
set -u
NAME=${1:-}
FIT=${2:-/tmp/opencode/fit.txt}
SRC="presentations/$NAME/src"
[ -n "$NAME" ] || { echo "usage: check-listings.sh <NAME> [fit.txt]" >&2; exit 2; }
[ -r "$FIT" ] || { echo "error: $FIT is not readable; run pdftotext -layout build/$NAME.pdf $FIT first" >&2; exit 2; }
[ -d "$SRC" ] || { echo "error: $SRC not found" >&2; exit 2; }
LIST=$(mktemp) || exit 2
trap 'rm -f "$LIST"' EXIT
find "$SRC" -type f | sort > "$LIST"
awk -v listf="$LIST" -v src="$SRC" '
  {
    key = $0
    gsub(/[ \t\r]+/, "", key)
    if (key == "") next
    seen[key] = 1
    d = key
    sub(/^[0-9]+/, "", d)            # variant without leading line-number margin
    if (d != key) seen[d] = 1
  }
  END {
    bad = 0
    while ((getline f < listf) > 0) {
      ln = 0
      while ((getline line < f) > 0) {
        ln++
        key = line
        gsub(/[ \t\r]+/, "", key)
        if (key == "") continue
        if (!(key in seen)) {
          printf "%s:%d: %s\n", f, ln, line
          bad++
        }
      }
      close(f)
    }
    close(listf)
    if (bad == 0)
      print "OK: every source line of " src " is rendered on a single physical line"
    else
      printf "FAIL: %d source line(s) are wrapped or clipped in the PDF (see above)\n", bad
    exit bad ? 1 : 0
  }
' "$FIT"
