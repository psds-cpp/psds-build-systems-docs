---
name: build
description: Building LuaTeX documents in this project
compatibility: opencode
---

# Build single presentation

Use this skill when testing build of document in progress.
It will enable you to build one document and not all of them and
you will see compilation logs in the same command:

```shell
nix develop --command make <NAME>.pdf
```

where `<NAME>.pdf` is build target from Makefile.

### Build Artifacts
* **Target PDF:** Appears in `build/<NAME>.pdf` upon successful compilation.
* **Log File:** If compilation fails or warns, inspect `build/<NAME>.log` to
  diagnose the issue.

*Note: If the build hangs, it might be waiting for user input due to a LaTeX error.
Ensure your Makefile passes non-interactive flags, or check the log file immediately.*

# Clean build folder

In some cases intermediate files may stand in the way of successfull compilation
and you may want to delete them.
Use command:

```shell
nix develop --command make clean
```
