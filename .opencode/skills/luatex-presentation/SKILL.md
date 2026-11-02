---
name: luatex-presentation
description: Skill for writing and editing LuaTex presentations in this project
---

This skill extends common rules for documents for all types from skill
`luatex-document` and specifies these rules for presentation documents
category.

# When to use

When in need to create new LuaTeX presentation or change existing one.

# Add new presentation

- Every presentation must have a number.
  Numbers represent the order in which documents are read.
  First number is `01`, then `02`, `03`, etc.
  The project does not support more than 100 documents.

- Each presentation gets its own subfolder in `presentations`.
  The `.tex` file lives inside that subfolder with the same
  name.
  Example: `presentations/01-cmake/01-cmake.tex`.

- Every presentation gets its own rule in `Makefile`.
  The generic `%.pdf: presentations/%.tex` pattern rule does
  not match files inside subfolders, so a dedicated target
  with prerequisites and a `$(call generate_pdf,$<,$@)`
  recipe is required.
  Also add entries to the `build`, `help` and `install`
  targets.
  See the "Add new document" section of the
  `luatex-document` skill for the full recipe.

- Presentations must be installed to `$(PREFIX)/presentations/` folder.

- Use Beamer with 16:9 aspect ratio and 8pt base font size.
  Example:
  ```tex
  \documentclass[compress, 8pt, aspectratio=169]{beamer}
  ```
  If content frequently does not fit the slides, change the base
  font size via the `documentclass` option (e.g. `8pt`) rather than
  shrinking individual frames.

- Use `presentationtemplate` template.
  Example:
  ```tex
  \usepackage{presentationtemplate}
  ```

- Load the listing and terminal packages with reduced font sizes
  (reference convention):
  ```tex
  \usepackage[fontsize=\footnotesize, linenosfontsize=\tiny,
    askip=3mm]{mylisting}
  \usepackage[fontsize=\footnotesize, askip=3mm]{terminal}
  ```

- The presentation sets only its name via `\title`.
  Do not override `\subtitle` from the template.
  Do not use `\setbeamertemplate`, `\setbeamerfont` or local
  `\setlength` hacks in the presentation — all beamer customization
  (title page, frame title font, footnote style, spacing) lives in
  `presentationtemplate.sty`.
  The frame title font size must be identical in all presentations:
  if a title does not fit, shorten the title, do not shrink the font.

# Writing presentations

- Keep text as short as possible.
  Most of the presentation content should be code listings
  with examples and terminal windows.

- Use russian language.
  Presentations are for Russian natives.

- Use other presentations as references (if there are any) when in doubt.
  They may have manual fixes which user added manually.
  The reference repository
  <https://github.com/cppdevcourse/documents> (its presentations,
  packages and `new-presentation` skill) is the primary reference
  for conventions.

- When in need to list several homogeneous ideas use `itemize` environment.
  Do not use `itemize` if ideas/sentences are not strictly homogeneous:
  present such material as plain text (a sequence of sentences) instead.
  Good:
  ```tex
  Object property:
  \begin{itemize}
    \item identifier
    \item type
  \end{itemize}
  ```
  Bad:
  ```tex
  \begin{itemize}
    \item C language was created in 1972 ...
    \item C language does not have classes ...
  \end{itemize}
  ```

- Use `fragile` for frames when using code listings and terminal windows.

- When a code listing and a terminal window are adjacent on a frame,
  add visible vertical space between them (e.g. `\vspace{0.5em}`);
  they must not touch.

- Overfulls are not allowed (check `Validating presentations` below)

- Adjust text size in text, code listings and terminal windows so it fits
  the frame.
  Body text must not be smaller than `\small`.
  Code listings and terminal windows use `\footnotesize` via package
  options (see "Add new presentation" above).
  If it does not fit, split frame in two.

- Frame content must not touch the bottom edge of the slide:
  there must be a visible margin between the last content line and
  the frame number.
  If content reaches the edge, reduce the font size or split the frame.

- When adding footnotes, use separate `\footnotemark` and
  `\footnotetext{...}`.
  Never write footnote numbers by hand: no optional argument,
  numbering must be automatic.
- A footnote mark must be attached to a word in the text:
  not to a code listing, not to a frame title, and not floating
  in empty space (e.g. on its own line at the end of the frame).
  Putting a footnote on a code listing is forbidden: the number
  ends up under the listing and looks bad.
- Footnote text must contain no title or commentary —
  the URL itself is enough: `\footnotetext{\url{https://...}}`.
  Write each URL on one source line (keep it under 100 characters;
  a line break inside `\url{...}` inserts a space into the URL).

- Columns must be top-aligned.

- Tables must have visible borders: column separators (`|`) and
  horizontal rules (`\hline`) at the top and bottom of the table
  and under the header row.

- Slides without title are forbidden.

## Tasks

- Project has designated package for rendering tasks for students
  (`packages/mytask.sty`).
  Use the `mytask` environment to give a task on the frame.
  Edit this file only in great need as it potentially affects all other documents.
  You must ask for user's approval if change is to be applied to a package.
  Example:
  ```tex
  \begin{mytask}
  Сделайте рефакторинг этого метода.
  \end{mytask}
  ```

# Validating presentations

All validation instruments must be executed within the `nix develop` environment.
After running `nix develop --command make <NAME>.pdf`,
perform these automated checks to ensure the presentation is flawless:

1. Check for Horizontal Text Overflow (Overfull lines):
    Run the following command to detect if text or code goes past the right margin.
    If it returns lines, you must wrap the text or reduce the font size
    (but no smaller than `\small`).
    ```shell
    grep -n "Overfull \\hbox" build/<NAME>.log
    ```

2. Check for Code Line Wrapping (mandatory, mechanical):
    Minted with `breaklines` wraps long lines SILENTLY: no Overfull
    appears in the log, so check 1 cannot catch this.
    ```shell
    mkdir -p /tmp/opencode && pdftotext -layout build/<NAME>.pdf /tmp/opencode/fit.txt
    ```
    Then verify that EVERY non-empty line of every file in
    `presentations/<NAME>/src/` is contained in a SINGLE physical
    line of `/tmp/opencode/fit.txt` (compare after removing all
    whitespace from both the source line and each physical line).
    If a source line is split across two physical lines, the listing
    overflows the frame width: reduce the listing font size or split
    the listing/frame.
    Also inspect `/tmp/opencode/fit.txt` to ensure no code lines are
    broken or clipped.

3. Check PDF Metadata & Page Count:
    Verify that the document compiled with the correct geometry and that the
    page count matches expectations:
    ```shell
    pdfinfo build/<NAME>.pdf
    ```

4. Check that code listings come from source files:
    All code listings must use `myinputlisting` with source files in the
    document's `src/` folder.
    In-place listings (`myinplacelisting`, `mytitledinplacelisting`) are
    only allowed for fragments which cannot exist as real files
    (broken or commented-out code).
    ```shell
    grep -n "myinplacelisting\|mytitledinplacelisting" presentations/<NAME>/<NAME>.tex
    ```
    If it returns lines, move the code to `src/` files and switch frames
    to `myinputlisting`, or explain in a comment why in-place is required.

5. Check source line width:
    LaTeX source lines must stay under 100 characters.
    ```shell
    awk 'length($0) > 100 { print FILENAME ": " FNR }' presentations/<NAME>/<NAME>.tex
    ```
    If it returns lines, wrap them.

6. Check bottom margin (visual):
    Frame content must not touch the bottom edge of the slide
    (there must be a visible margin before the frame number).
    ```shell
    nix develop --command sh -c \
      'pdftoppm -png -r 80 build/<NAME>.pdf /tmp/opencode/page'
    ```
    Inspect `/tmp/opencode/page-*.png`.
    If content touches the edge, reduce the font size or split the
    frame.
