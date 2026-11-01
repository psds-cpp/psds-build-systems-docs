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

- All presentations must be added to `presentations` folder.

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

## Tasks

- Project has designated package for rendering tasks for students
  (`packages/mytask.sty`).
  Use it to show compilation error or how to run something.
  Default escape sequence is exclamation marks surrounding TeX code.
  Edit this file only in great need as it potentially affects all other documents.
  You must ask for user's approval if change is to be applied to a package.
  Example:
  ```tex
  \begin{task}[fontupper=\footnotesize]
  Сделайте рефакторинг этого метода.
  \end{task}
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
