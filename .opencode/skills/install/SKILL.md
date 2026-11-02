---
name: install
description: Compiling and installing PDF documents in this project
---

# When to use

When finishing task and checking if everything is on order.
Same actions will run in release workflow (see `.github/workflows/release.yml`).

# Install all documents

To compile and install all documents in this project:

1. Add all relevant files to a Git index with `git add`.

2. Build Nix derivation:
  ```shell
  nix build .
  ```

Use `build` skill to debug possible errors.

## Installation artifacts

* `result/presentations/*.pdf`: symlink to compiled documents in Nix storage.
