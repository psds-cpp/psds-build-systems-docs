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

- Use Beamer with 16:9 aspect ratio.
  Example:
  ```tex
  \documentclass[compress, aspectratio=169]{beamer}
  ```

- Use `presentationtemplate` template.
  Example:
  ```tex
  \usepackage{presentationtemplate}
  ```

- Use `\title` to set presentation title.
  All else defined in template.

# Writing presentations

- Keep text as short as possible.
  Most of the presentation content should be code listings
  with examples and terminal windows.

- Use russian language.
  Presentations are for Russian natives.

- Use other presentations as references (if there are any) when in doubt.
  They may have manual fixes which user added manually.

- When in need to list several homogeneous ideas use `itemize` environment.
  Do not use `itemize` if ideas/sentences are not strictly homogeneous.
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

- Overfulls are not allowed (check `Validating presentations` below)

- Adjust text size in text, code listings and terminal windows so it fits
  frame.
  It should not be smaller than `\small`.
  If it does not fit, split frame in two.

- When adding footnotes, use separate `\footnotemark{}` and
  `\footnotetext{...}`.

- Columns must be top-aligned.

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

2. Check for Code Line Wrapping:
    Convert the PDF to raw layout text and inspect if long lines of code were
    abruptly wrapped into new lines inside listings:
    ```shell
    mkdir -p /tmp/opencode && pdftotext -layout build/<NAME>.pdf /tmp/opencode/fit.txt
    ```
   Inspect `/tmp/opencode/fit.txt` to ensure no code lines are broken or clipped.

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
