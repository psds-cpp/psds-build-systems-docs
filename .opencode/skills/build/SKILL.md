---
name: build
description: Building LuaTeX documents in this project
compatibility: opencode
---

# Build single presentation

Use this skill when testing build of document in progress.
It will enable you to build one document and not all of them:

```shell
nix develop --command make <NAME>.pdf > /tmp/opencode/<NAME>.build.out 2>&1
```

where `<NAME>.pdf` is build target from Makefile.

### Output discipline

Hard limit: the LLM gateway rejects request bodies larger than
~1 MiB with HTTP 413, and the session dies. Every byte a command
prints into the tool result is re-sent to the provider on EVERY
subsequent step of the session, so keep tool results small forever:

- Always redirect the whole build output to a file as shown above.
  Never let full LaTeX logs flow into the tool result.
- The rule applies to every command that can print more than a few KB
  of output: any `nix build` / `nix develop` / `make` run,
  e.g. `nix develop --command make -j1 all > /tmp/opencode/all.build.out 2>&1`.
- After the build, inspect only small windows of the output file:
  ```shell
  tail -n 30 /tmp/opencode/<NAME>.build.out
  grep -n -E "^!|Overfull|Emergency" /tmp/opencode/<NAME>.build.out
  ```
- Do not read or cat the whole build output file.
- Give the command a timeout of at least 600000 ms.
  A cold `nix develop` is slow.
- If a step fails with HTTP 413 (Payload Too Large), the session
  history is already over the limit: do not retry in the same
  session — report to the PM; a fresh subagent session with a
  compact prompt continues the work.

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
nix develop --command make clean > /tmp/opencode/clean.out 2>&1
```
