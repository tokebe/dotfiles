# Package manager adapters

Package manager interface shims used in `PACKAGE_MANAGERS.toml`, run via `bash -c` with
the dots shell env.

Rules:

- `set -uo pipefail`, never `-e`. Stream output to stdout/stderr.
- **install** (`<mgr>-install {packages}`):
  - single package (`$# -eq 1`): exit non-zero on failure.
  - batch (`$# > 1`): best-effort, exit 0 (install what you can, skip broken).
- **check** (`<mgr>-check`): count as a bare integer on the last stdout line, detail on
  stderr, never abort.
- **detect**: exit 0 iff present.
- **refresh** / **upgrade**: may fail.
- **list_installed**: one package name per line.
