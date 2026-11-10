#!/bin/sh
# check-wraps.sh <NAME> [FIT]
#
# Mechanical check: every logical line of every in-place
# `terminalwindow`, `myinplacelisting` and
# `mytitledinplacelisting` in presentations/<NAME>/<NAME>.tex
# must be rendered inside a SINGLE physical line of the
# pdftotext -layout dump of build/<NAME>.pdf.
#
# Why a separate check: check-listings.sh only covers files
# from src/. In-place terminal windows (tcolorbox with
# breaklines) and in-place listings wrap SILENTLY as well
# (no Overfull in the log), so this check is mandatory after
# every build.
#
# Terminal lines may carry TeX markup, so each line is first
# rendered to its visible text: the `!\shellcommand{...}!`
# prompt becomes `> ...`, `!\myhighlight{...}{...}!` unwraps
# to its payload, `!\dots!`/`\dots` become the ellipsis
# character, escaped characters (`\_`, `\-`, `\&`, `\$`, `\#`,
# `\%`, `\char"5E`) unescape, other `!TeX!` escape regions
# unwrap to their payload, and the document's own \newcommand
# macros from the preamble are expanded (both the one-line
# form and the `name}% / {body}` two-line form).
# A line written as `part1\\part2` in the source is an
# intentional two-line command: each part is checked
# separately.
#
# Matching is the same as in check-listings.sh: all whitespace
# is removed; a line passes if it equals one physical line or
# is a substring of ONE physical line (covers pdftotext column
# merging and minted line-number margins). A wrapped line is
# split across physical lines and can never match.
#
# Usage (from the project root, inside nix develop):
#   nix develop --command pdftotext -layout build/<NAME>.pdf /tmp/opencode/fit.txt
#   nix develop --command sh .opencode/skills/luatex-presentation/scripts/check-wraps.sh <NAME>
#
# Output: one line per violating source line:  file:line: content
# Exit codes: 0 = no violations, 1 = violations found, 2 = usage error.
set -u
NAME=${1:-}
FIT=${2:-/tmp/opencode/fit.txt}
TEX="presentations/$NAME/$NAME.tex"
[ -n "$NAME" ] || { echo "usage: check-wraps.sh <NAME> [fit.txt]" >&2; exit 2; }
[ -r "$FIT" ] || { echo "error: $FIT is not readable; run pdftotext -layout build/$NAME.pdf $FIT first" >&2; exit 2; }
[ -r "$TEX" ] || { echo "error: $TEX not found" >&2; exit 2; }
awk -v TEXF="$TEX" '
  function strip(s) { gsub(/[ \t\r]/, "", s); return s }

  function expand(s,   pass, i, changed, body) {
    for (pass = 1; pass <= 4; pass++) {
      changed = 0
      for (i = 1; i <= nmacros; i++) {
        if (index(s, "\\" mname[i]) > 0) {
          body = mbody[i]
          gsub(/&/, "\\&", body)
          gsub("\\\\" mname[i], body, s)
          changed = 1
        }
      }
      if (!changed) break
    }
    return s
  }

  function render(s,   m, b, inner) {
    gsub(/!\\dots!/, "\\dots", s)
    while (match(s, /!\\myhighlight\{[^{}]*\}\{[^{}]*\}!/)) {
      m = substr(s, RSTART, RLENGTH)
      b = index(m, "}{")
      inner = substr(m, b + 2, length(m) - b - 3)
      s = substr(s, 1, RSTART - 1) inner substr(s, RSTART + RLENGTH)
    }
    if (s ~ /^!\\shellcommand\{/) s = "> " substr(s, 16)
    if (s ~ /\}!$/) s = substr(s, 1, length(s) - 2)
    # generic escape region: !TeX! -> TeX (fallback for
    # regions that are not shellcommand/myhighlight/dots)
    while (match(s, /!\\[^!]*!/)) {
      m = substr(s, RSTART, RLENGTH)
      inner = substr(m, 2, length(m) - 2)
      s = substr(s, 1, RSTART - 1) inner substr(s, RSTART + RLENGTH)
    }
    s = expand(s)
    gsub(/\\char"5E/, "^", s)
    gsub(/\\_/, "_", s)
    gsub(/\\&/, "&", s)
    gsub(/\\$/, "$", s)
    gsub(/\\-/, "-", s)
    gsub(/\\#/, "#", s)
    gsub(/\\%/, "%", s)
    gsub(/\\dots/, "\342\200\246", s)
    gsub(/\\/, "", s)
    return s
  }

  function okpart(vis,   k) {
    if (vis == "") return 1
    if (vis in seen) return 1
    for (k = 1; k <= physn; k++)
      if (index(phys[k], vis) > 0) return 1
    return 0
  }

  # ---- file 1: the pdftotext -layout dump (physical lines)
  FNR == NR {
    key = strip($0)
    if (key == "") next
    phys[++physn] = key
    seen[key] = 1
    next
  }

  # ---- file 2: the .tex source
  # two-line macro definition: \newcommand{\name}%
  /^[ \t]*\\(re)?newcommand\{\\[A-Za-z]+\}%[ \t]*$/ {
    if (match($0, /\\(re)?newcommand\{\\([A-Za-z]+)\}/)) {
      m = substr($0, RSTART, RLENGTH)
      p = index(m, "{\\")
      p2 = index(substr(m, p + 2), "}")
      mname[++nmacros] = substr(m, p + 2, p2 - 1)
      mbody[nmacros] = ""
      pending = nmacros
    }
    next
  }
  pending && /^[ \t]*\{[^{}]*\}[ \t]*$/ {
    m = $0
    sub(/^[ \t]*\{/, "", m)
    sub(/\}[ \t]*$/, "", m)
    mbody[pending] = m
    pending = 0
    next
  }
  # one-line macro definition: \newcommand{\name}{body}
  /^[ \t]*\\(re)?newcommand\{\\[A-Za-z]+\}\{[^{}]*\}[ \t]*$/ {
    if (match($0, /\\(re)?newcommand\{\\([A-Za-z]+)\}\{[^{}]*\}/)) {
      m = substr($0, RSTART, RLENGTH)
      p = index(m, "{\\")
      p2 = index(substr(m, p + 2), "}")
      b = index(m, "}{")
      mname[++nmacros] = substr(m, p + 2, p2 - 1)
      mbody[nmacros] = substr(m, b + 2, length(m) - b - 2)
    }
    next
  }
  # environment start
  /\\begin\{(terminalwindow|myinplacelisting|mytitledinplacelisting)\}/ {
    if (match($0, /\\begin\{[A-Za-z]+\}/))
      kind = substr($0, RSTART + 7, RLENGTH - 8)
    inenv = 1
    next
  }
  # environment end
  inenv && /\\end\{(terminalwindow|myinplacelisting|mytitledinplacelisting)\}/ {
    inenv = 0
    next
  }
  # content lines of an in-place environment
  inenv {
    nlines++
    lraw[nlines] = $0
    lno[nlines] = FNR
    lkind[nlines] = kind
    next
  }

  END {
    # sort macros by name length, longest first (avoids
    # expanding a prefix of a longer macro name)
    for (i = 2; i <= nmacros; i++) {
      nm = mname[i]; nb = mbody[i]
      j = i - 1
      while (j >= 1 && length(mname[j]) < length(nm)) {
        mname[j + 1] = mname[j]; mbody[j + 1] = mbody[j]
        j--
      }
      mname[j + 1] = nm; mbody[j + 1] = nb
    }
    bad = 0
    for (i = 1; i <= nlines; i++) {
      line = lraw[i]
      if (lkind[i] == "terminalwindow") {
        # an intentional `\\` line break: check each part
        # separately, report the source line only once
        okall = 1
        np = split(line, parts, "\\\\\\\\")
        for (j = 1; j <= np && okall; j++)
          if (!okpart(strip(render(parts[j])))) okall = 0
      } else {
        okall = okpart(strip(line))
      }
      if (!okall) {
        printf "%s:%d: %s\n", TEXF, lno[i], line
        bad++
      }
    }
    if (bad == 0)
      print "OK: every in-place terminal and listing line is rendered on a single physical line"
    else
      printf "FAIL: %d line(s) are wrapped or clipped in the PDF (see above)\n", bad
    exit bad ? 1 : 0
  }
' "$FIT" "$TEX"
