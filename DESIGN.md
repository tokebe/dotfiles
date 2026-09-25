# Dotfiles Design

Living plan for the post-dotbot rewrite. Terse, example-driven, evolves as we go.

## Goals

- One repo: sync config, **edit-in-place** (symlinks, live), install software, hold
  scripts.
- Readable data (TOML), hackable logic (bash + python).
- Per-machine behavior via automatic detection + explicit override.
- Bootstrap most of a new machine from a README one-liner (not necessarily one command
  total).

## Layout

```
bootstrap                                  # bash: cold start (lands git+uv, clones, syncs, execs shell)
pyproject.toml  uv.lock                    # uv project: entrypoints as console scripts + deps
dot/                                       # python: types/ (pydantic models), entrypoints, libs (detect, dispatch)
linked/                                    # default profile's config-file pool
  .config/  home/
scripts/                                   # bash: utilities, hooks
  pkg_adapters/                            # single-purpose adapter scripts (one per complex action)
CONFIG.toml  SOFTWARE.toml                 # default (always-on) profile
PACKAGE_MANAGERS.toml                      # global: manager commands (not layered)
profiles/<name>/                           # overlay profiles; dirname is a label only
  CONFIG.toml  SOFTWARE.toml
  linked/  scripts/
```

## Language boundary

- **python** (pydantic-settings for config): all entrypoints and logic — `deploy`, `link`, `install`,
  `update`, activation + hook-order resolution, the manager dispatch, detection.
  Hooks and manager commands run as bash via `subprocess`.
- **bash**: only `bootstrap` (pre-clone) plus small utility / hook / adapter scripts.
- No jq for logic. No env-globals to memorize — detection is one python module, imported
  on demand (`bootstrap`, being pre-clone, does its own inline checks).

## Python env (uv)

The repo is a **uv project** (`pyproject.toml` + `uv.lock`). uv provides its own Python
(≥3.14) and, on `uv sync`, installs the entrypoints as console scripts into `.venv/`.

- `bootstrap`'s job: land the **pre-clone prerequisites** (`git` to clone, plus any deps the
  Python layer can't yet install itself), install uv, clone the repo, run `uv sync`, then
  `exec` an interactive shell with the env active — you land in a working shell with the
  commands available. It's the one place that must install software before the Python
  dispatch exists, so it does the work itself, system-agnostically.
- **Landing prereqs.** bootstrap installs the prereqs (git, uv, …) with a per-distro
  `case` over the detected system — `apt`/`dnf`/`pacman`/`zypper`/`apk` + `brew` — each
  branch owning its own `-y`, index refresh, and sudo (Linux, not macOS/brew). The set is
  small and the names stable, so the case stays short and stays under our control.
- The managed `zshrc` puts the project's env on `PATH`, so every later shell has
  `deploy`/`link`/`install`/`update` as bare commands — script shortcuts for free.
- Config is parsed + validated with **pydantic / pydantic-settings** (each TOML maps to a
  model in `dot/types/`). `uv run <name>` works without activation.

## Detection

One python module returns facts: `os`, `distro`, `architecture`, `host`, `desktop` — imported
wherever needed (`import detect`), cheap and idempotent. `bootstrap`, being pre-clone
bash, does its own inline `uname`/`/etc/os-release` checks.

## Profiles (overlay model)

Effective config = `default` (root) + each active profile, in activation order. Dirnames
are labels; activation lives in each profile's `CONFIG.toml`.

```toml
# profiles/desktop/CONFIG.toml
[profile]
priority = 10                              # higher = applied later = wins on conflict
when = { os = "linux", distro = "fedora", desktop = true }   # keys match detection facts
# when = { cond = 'command -v niri >/dev/null' }             # cond overrides its siblings (warns)
```

- `when` keys (`os`, `distro`, `architecture`, `host`, `desktop`) match detection facts;
  `desktop` may be a bool or a specific name.
- `cond` is a shell expression placed **inside** `when`; when present it overrides its
  sibling keys (warns, doesn't error). Evaluated via bash.
- Multiple profiles may match → they **stack**, applied by ascending `priority` (default
  10; the default/root layer first); later wins per conflict.

Override (skip detection, activate exactly these):

```
install                       # detect
install mac debian-tty        # no detection; activate these profiles verbatim
```

`link`, `install`, `deploy` take the same positional profile args.

## SOFTWARE.toml

Union per manager across active layers. Inline per-item overrides (omnipkg-style):

```toml
system = [
  "clang",
  ["fd", "fd-find"],                       # aliases — try in order
  { default = "go", debian = "golang" },   # per-distro — key = distro
]
brew  = ["jq", "bat", "ripgrep"]
cargo = ["tealdeer"]
```

Resolution (python, written once):

```python
def resolve(e, distro):
    if isinstance(e, str):
        return e  # same name everywhere
    if isinstance(e, list):
        return e  # aliases, try in order
    return e.get(distro, e["default"])  # explicit per-distro
```

An alias list resolves to the first candidate the manager accepts, tried in order.

**Install batching.** `install` maximally batches: plain names go into one `manager install
name1 name2 …` call; alias lists and other special entries install on their own. A
**single-candidate** list is treated like a plain install — streamed live, and a failure
aborts that manager (marking it ✗). A **multi-candidate** list is the real "try in order":
each candidate runs with output captured/suppressed, stopping at the first success; only the
final result's output is kept (on success, or the last failure), and an all-fail group marks
the manager ✗. Per-manager failures don't abort the run — each manager section is bracketed
by a rule that resolves to ✓/✗.

**URL-based managers (gearlever).** A dict entry with a `url` key is *not* per-distro — it's
a `{ name, url }` pair (reusing the `dict[str, str]` slot, no new type). `resolve` keys off
that `url`: return the pair as-is instead of selecting by distro. The adapter gets both —
`name` to match `gearlever --list-installed` for the idempotency skip, `url` to download and
to set as the update source. So the `system` name list and gearlever's URL list share one
type; only the presence of `url` distinguishes them.

Manager keys (`system`, `brew`, `cargo`, …) are defined in `PACKAGE_MANAGERS.toml`;
`system` routes to whichever manager `native_on` resolves to for this machine (see below).

## PACKAGE_MANAGERS.toml

Global (not layered). One entry per manager, feeding the **single shared dispatch** so
`install` (install/sync) and `update` (upgrade) never duplicate logic. Each of
`detect`/`install`/`upgrade`/`check` is a bash command; `{packages}` is substituted with
the resolved names. Simple actions are one-liners; a complex one just calls its own
single-purpose script under `scripts/pkg_adapters/` (no mode/action args to handle).

`check` prints an **integer count** of available updates on stdout (not raw listings) — so
the dispatch can compare managers uniformly. Count where the tool exposes one inline
(`brew outdated --quiet | wc -l`); parse into a count via an adapter where it doesn't
(`gh extension upgrade --all --dry-run` → count the upgradable lines).

`refresh` (optional) syncs the manager's package index; the dispatch runs it once before
`check` and before `upgrade`. Set it only for managers that read a stale local snapshot
(`brew`: `brew outdated`/`brew upgrade` won't fetch on their own). Managers that query
their remote live (uv, cargo, flatpak, gh-ext) omit it.

```toml
[brew]                                # all inline
refresh = "brew update"               # brew outdated/upgrade read a local snapshot
detect  = "command -v brew"
install = "brew install {packages}"
upgrade = "brew upgrade"
check   = "brew outdated"

[dnf]                                 # mix: inline where simple, adapter script where not
native_on = ["fedora", "rhel", "centos"]   # this is the `system` manager on these distros
detect  = "command -v dnf"
install = "scripts/pkg_adapters/dnf-install {packages}"   # batch install, skip unavailable/broken
upgrade = "sudo dnf upgrade -y"
check   = "scripts/pkg_adapters/dnf-check"                # normalizes exit 100
```

- Dispatch is python; every field runs via bash. A manager is skipped when `detect` fails.
- Adapter scripts are single-purpose — one action each, invoked exactly like a one-liner,
  so they never branch on a mode. Reach for one when a command needs loops, odd exit codes,
  or alias fallback.
- **Auto-confirm the manager, never shortcut sudo.** `install`/`upgrade` pass the manager's
  own non-interactive flag (`brew --yes`, `dnf -y`, `flatpak -y`; gh/uv/cargo don't prompt);
  a manager with no such flag gets its confirmations fed via `yes y | …` (gearlever). A sudo
  *password* prompt is left to block and be answered by the user — we never pipe a password,
  cache credentials, or add NOPASSWD.
- `native_on` lists the distros a manager is the `system` choice for (plus `"macos"`, and
  `"*"` as the cross-platform fallback — brew uses `["macos", "*"]`). A python resolver
  (`utils/system_manager.py`) picks, among installed candidates, the one matching this
  machine's os/distro, else the `"*"` fallback; SOFTWARE.toml's `system` list routes there.
- Each distro system manager (`dnf`, and future `apt`/`pacman`/`zypper`/`apk`) is its own
  small adapter with a `native_on`. The initial bring-up (installing these plus other
  prereqs on a bare machine) is handled by `bootstrap` with per-distro `case` branches.

## CONFIG.toml

Per-layer behavior — activation, links, and hooks in one file (SOFTWARE.toml stays
separate). Links are **verbatim** (source name = target name). A top-level `force_links`
sets the default link behavior for the file.

```toml
# profiles/desktop/CONFIG.toml   (root is the same shape, minus [profile])
force_links = false                       # default: don't clobber an existing real target
create = ["~/Applications", { dir = "~/.ssh", mode = "0700" }]   # path str, or table w/ mode

[profile]                                 # omitted in the default/root layer
priority = 10                             # higher = applied later = wins on conflict
when = { os = "linux", distro = "fedora", desktop = true }

[links]                                   # target = key; value = repo-relative src or table
"~"                        = "linked/home/*"       # /* = link contents, keep target real
"~/.config"                = "linked/.config/*"
"~/.config/tmux/tmux.conf" = "linked/tmux/tmux.conf"   # no /* → fold (link file/dir)

[links."~/.config/nvim"]                  # table form: src + per-link flags
src   = "linked/.config/nvim"
force = true                              # overrides top-level force_links

[[clean]]                                 # one entry per dir to sweep of dead repo symlinks
dir       = "~"
recursive = false

[[hooks.after.install]]                   # before/after a named event; runs as bash
name    = "Prepare Neovim"
command = "nvim --headless '+Lazy! sync' +qa"
mode    = "auto"                          # quiet | auto | verbose
```

- **Links.** Target is the key; the bare value or the table's `src` is resolved against the
  **layer's base** — the repo root for the default layer, the profile's own directory
  (`profiles/<name>/`) for a profile — so `src` typically starts with `linked/…`. A `/*` on
  the source means **link the contents, not the folder itself** (target dir stays real);
  expansion uses `pathlib.Path.glob`, which matches dotfiles and supports patterns — **not**
  `glob.glob('*')`, which silently skips hidden entries (the bug that bit dotbot); a glob
  matching nothing is reported. `force = true` clobbers an occupied target — a wrong symlink
  is unlinked, a real file/dir is moved to the trash (recoverable, via `gtrash`, falling back
  to a confirmed `rm`) before linking; without `force` an occupied target is left alone. The
  top-level `force_links` is the default; a per-link `force` (only when set — it defaults to
  unset) overrides it. A missing source is skipped (no dead link). Links **merge across all
  active layers** into one resolved set; at a given target, the **last active layer wins**.
- **Create.** Ensures dirs exist before linking (dotbot `create`); union across active
  layers. An entry is a path string, or a table `{ dir, mode }` (`mode` default `0777`).
- **Clean.** `link` prunes dead symlinks pointing into the repo. `clean` is a list of dirs
  (string or `{ dir, recursive, force }`) to sweep; `recursive` is per-dir, default off.
  `force` also prunes dead symlinks pointing *outside* the repo (ones we don't own).
- **Activation** (`[profile]`) — see Profiles above; omitted in the default layer.
- **Hooks.** `[[hooks.before.<event>]]` / `[[hooks.after.<event>]]` attach to a named
  lifecycle event (`link`, `install`, `update`, …). Each hook is `{ name, command, mode }`;
  `command` runs as bash via subprocess, list order = run order, across layers by `priority`.
  Each runs under a spinner that resolves to ✓/✗; `mode` controls output — `quiet` (status
  only), `auto` (transient window, kept only on failure), `verbose` (always kept).

Generic case: `"~/.config" = "linked/.config/*"` links all of a layer's `.config` children. A
profile overrides or adds a config just by dropping it in `profiles/<name>/linked/.config/`
— no CONFIG entry needed unless the mapping or a flag differs.

## Entrypoints

```
bootstrap   # bash: install uv + prereqs, clone, uv sync, exec a shell with the env active
deploy      # python: link + install + update (full bring-up / refresh)
link        # python: create dirs, prune dead repo links, apply link rules (CONFIG.toml)
install     # python: install/sync SOFTWARE.toml via shared dispatch; hooks fire implicitly
update      # python: upgrade installed packages via shared dispatch (ignores lists)
adopt       # python: move an existing real path into the repo, then replace it with a symlink
```

Hooks are no longer a command's job — they fire implicitly on their lifecycle event
(`before`/`after` `link`/`install`/…), so `install` is just "install packages" and the
old `pkg` command is gone (folded into `install`). `deploy` runs `update` after `install`,
so a full deploy also brings existing packages current.

`adopt` takes two positionals — `<src>` (an existing real path) and `<dest>` (its home in
the repo, e.g. `linked/.config/foo` or `profiles/<name>/linked/…`) — moves `src` to `dest`,
then symlinks `src` back at `dest`; the `dest` path picks the layer, so there's no profile arg.

`adopt`, `deploy`, `link`, `install`, `update` all accept `--dryrun`/`-d` — print planned
actions (dir creates, links, cleans, installs, upgrades, hooks, adoptions) without executing.
`bootstrap` doesn't.

Once the env is active (post-`bootstrap`, or auto via the managed `zshrc`), these are bare
commands; otherwise `uv run <name>`. Interaction ladder, surgical → full:

```
update brew                  # upgrade just brew, no lists
update                       # upgrade everything installed
install                      # software for detected profiles (hooks fire implicitly)
install mac                  # same, profiles forced
deploy                       # link + install + update
bash <(curl …/bootstrap)     # bare metal
```

## Open

- `SOFTWARE.toml` sectioning within a layer — flat, or grouped keys?
- `pip` manager — deferred; needs system-awareness (PEP-668 externally-managed: `--user` vs
  `--break-system-packages` per distro, no native upgrade-all). Not a static adapter.
- `adopt` when `dest` already exists in the repo — overwrite the tracked copy, or error?
