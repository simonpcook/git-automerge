Git Automerge Utilities
=======================

This repository contains a shell script to aid in the automatic rolling forward
of git repositores based on external upstream source code bases.

Sourcing `automerge-utils.sh` will add two shell functions to the environment
for rolling forward git repositories:

- `automerge_try` - The main automerge function. The usage is as follows:

  `automerge_try <DIR> <a.git> <branchA> <b.git> <branchB> <branchD>`

  In `<DIR>` (cloning `<a.git>` if it doesn't already exist), the function will
  add `<b.git>` as remote `<upstream>`, and merge `<b.git>/<branchB>` into
  `origin/<branchA>`, saving the result in branch `<branchD>`.
- `automerge_push` - Push the result of automerging. The usage is as follows:

  `automerge_push <DIR> <branchD>`

  In `<DIR>`, this simply force pushes `<branchD>` to the `origin` remote.

The overall automerge process is split up into these two parts for projects
that wish to automerge multiple sub-repositories, but only push the results if
every merge was successful.

Note: This script is currently intended to be used in a shell which
automatically exists when a command fails (e.g. `-x` is set in `sh`). Explicit
error checking will appear in a future version.
