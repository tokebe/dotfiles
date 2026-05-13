# PLUGINS.md

A summary of every plugin and config module loaded by this Neovim setup. Entry
point is `init.lua`, which pulls in `lua/base_config.lua`, then `lua/plugins.lua`
(which imports everything under `lua/behavior/`, `lua/bindings/`, `lua/integration/`,
`lua/integration/language-support/`, `lua/tools/`, and `lua/ui/`), then
`config.autocmds`, then `config.finish`. Leader is `<Space>`.

Each entry is three lines: (1) what the plugin/module is, (2) the specifics
(bindings, config knobs, hooks), and (3) the workflow it contributes to.

## Bootstrap / core

**`init.lua`** — top-level entry point, sets leader keys and branches on environment.
Sets `<Space>` as leader/localleader before plugins load; if launched from inside a nested `:term` (`$NVIM` set), loads only `flatten.nvim` and bails — otherwise proceeds to `base_config` → `filter.setup` → `lazy-backup` → `plugins` → `config.autocmds` → `config.finish`.
Gives you a single editor instance that transparently handles being launched from inside its own terminal (git commit messages etc.) without nesting real sessions.

**`lua/base_config.lua`** — plain `:set` options applied before any plugin runs.
Visual (scrolloff=10, cursorline, wrap+linebreak+breakindent, signcolumn=yes, colorcolumn=88, termguicolors), search (hlsearch+smartcase, diffopt with linematch:60), behavior (mouse=a, 2-space expandtab, clipboard=unnamedplus, undofile, updatetime=100, autoread, `q:` disabled), plus a block of neovide-specific toggles.
Establishes the consistent editor feel every plugin inherits — wrapping, clipboard integration, and linematch diffs are relied on across git/diffview/search plugins below.

**`lua/plugins.lua`** — lazy.nvim bootstrap and module orchestration.
Clones `folke/lazy.nvim` stable to stdpath if missing, then `require('lazy').setup` imports six folders: `behavior`, `bindings`, `integration`, `integration.language-support`, `tools`, `ui` with `change_detection.notify=true`.
Add a plugin by dropping a new spec file into the appropriate folder — no central list to edit.

**`lua/lazy-backup.lua`** — lockfile versioning hooked into `User LazySync`.
Copies `lazy-lock.json` to `lockfiles/{timestamp}_lazy-lock.json` after every `:Lazy sync`, scanning the folder and pruning to the 10 newest.
Safety net for plugin rollbacks — if an update breaks things, copy a prior lockfile back and `:Lazy restore`.

**`lua/filter.lua`** — user-managed persistent glob filter for file-search plugins.
`<Leader>of` opens a centered nui popup titled "File Search Glob Filter" pre-filled with `vim.g.PersistentFilter`; `t` inside the popup toggles enabled/disabled; `<Leader>otf` toggles from outside; `filter.getFilter()` returns the pattern (or empty if disabled) and is consumed by `fzf-lua.lua` and `grug.lua`.
One project-wide exclude pattern (default excludes node_modules, .venv, .git, __test__, built) keeps file pickers and project-wide search quiet without repeatedly retyping globs.

**`lua/util.lua`** — tiny helper module imported by several plugin specs.
Exposes `get_cwd_as_name()` (cwd sanitized to an identifier), `copy_table`, and a `keymap(modes, lhs, rhs, opts)` wrapper that registers via which-key with optional `desc`/`description`.
Keeps spec files terse and lets description metadata flow into which-key's popup.

**`lua/palette.lua`** — unified command palette over live nvim state.
`open()` gathers `nvim_get_commands` (global + buffer-local) and normal-mode `nvim_get_keymap` entries with a `desc`, formats each as `cmd  :Name  desc` / `key  lhs  desc` (`*` marker for buffer-local), then feeds an `fzf-lua.fzf_exec` picker; selecting a command pre-fills the cmdline (with trailing space for args), selecting a keymap feedkeys-replays the lhs. Sourced via `tools/palette.lua` and bound to `<Leader><Leader>`.
Replaces fzf-lua's keymaps-only picker — anything declared with `desc` (lazy `keys`, `vim.keymap.set`, `util.keymap`, `nvim_create_user_command`) shows up automatically without a parallel registration list. Convention for adding palette visibility: see "Palette discoverability" below.

### Palette discoverability

The palette reads only from nvim's live state, so visibility tracks declaration:

- **Lazy `keys = {…}` blocks** — set `desc` on each entry (already standard).
- **`vim.keymap.set` in `config`** — pass `{ desc = '…' }`.
- **`util.keymap`** — already takes `desc`/`description`; routes to which-key.
- **User commands** — pass `desc` to `nvim_create_user_command`. Plugin-defined commands without a `desc` still appear (searchable by command name); to add a description colocated with the plugin spec, redefine in `config`:

  ```lua
  config = function(_, opts)
    require('grug-far').setup(opts)
    pcall(vim.api.nvim_del_user_command, 'GrugFar')
    vim.api.nvim_create_user_command('GrugFar', function()
      require('grug-far').open()
    end, { desc = 'Project find/replace' })
  end,
  ```

  Or — namespace-clean alternative — create a wrapper command (`FindReplaceProject`) instead of shadowing the plugin's name.

**`lua/config/autocmds.lua`** — cross-cutting global autocommands applied last.
`FocusGained` and `BufEnter` run `checktime` on the current buffer to pick up external file changes; the `ModeChanged` luasnip-unlink autocmd is currently commented out (temporary snippet-behavior tweak), so after finishing a snippet chain the cursor may snap back into the last node until that comes back.
Keeps on-disk state synced (pairs with `auto-save.nvim`); snippet-state cleanup is off at the moment.

**`lua/config/finish.lua`** — post-plugin finalization step.
Requires `config.diagnostics` (for diagnostic config — loaded last so plugin-set signs don't override), then appends fillchars for eob/diff/horiz/horizup/horizdown/vert/vertleft/vertright/verthoriz so split corners and diff fills use the preferred box-drawing glyphs.
Guarantees diagnostic handlers and window-frame glyphs settle after every plugin has spoken.

**`lua/config/diagnostics.lua`** — custom diagnostic renderer/filter with toggles.
Configures `virtual_text` with `"{message} ({source})"` format, severity-sorted signs (error/warn/info/hint with custom glyphs), no update_in_insert, solid float border; replaces the builtin signs handler with a filter that drops "unused"/"never read" messages and keeps only the most-severe diagnostic per line; `<Leader>otd` toggles `vim.diagnostic.enable`, `<Leader>otD` swaps between virtual_text and virtual_lines.
Results in a quiet signcolumn (one sign per line) and replicates removed `neodim` behavior by filtering unused-variable warnings out of the gutter.

**`lua/config/sources.lua`** — single source-of-truth table for tools to install.
Lists LSPs (lua_ls, basedpyright, ruff, taplo, bashls, yamlls, marksman), DAPs (js, debugpy), formatters/linters (beautysh, yamlfix, stylua, luacheck, eslint_d, ruff, shellharden, shellcheck), and extra treesitter parsers (dap_repl, regex, markdown_inline, http, json, python, typescript, javascript, latex).
Adding a tool here auto-propagates through `mason-lspconfig`, `mason-null-ls`, `mason-nvim-dap`, `nvim-treesitter`, and `navbuddy`'s LSP preference list.

**`lua/config/filetype_excludes.lua`** — shared list of chrome/panel filetypes.
Contains ~40 filetypes (TelescopePrompt, Trouble, help, NvimTree, neo-tree, mason, lazy, WhichKey, dashboard, noice, toggleterm, spectre_panel, Navbuddy, fzflua, OverseerList/Output, grug-far, undotree, blink-cmp-*, NvMenu, dap-view/repl/term, neotest-*, oil/oil_preview, smear-cursor, DiffviewFiles, persistentfilterdata, qf, ...).
Imported by indent guides, illuminate, snacks, retrail, statuscol, early-retirement, context, lastplace, colorful-winsep, insert-inlay-hints, csvview, etc. so UI chrome doesn't get treated as editable content.

**`lua/config/misc-keybinds.lua`** — core non-plugin keymaps (loaded by which-key).
`<Leader>gf` format (normal + visual range), `<Leader>op` `:Lazy`, `<`/`>` prev/next buffer (the `<A-lt>`/`<A->>` tab-prev/next bindings are commented out — they were breaking bprev), `<S-Tab>` cycles tabs, `<Leader>wn/wt/wc` new buffer/tab / close tab, `<Leader>qq/qQ` quit / force quit, insert-mode `<C-l>`/`<C-h>` word-right/left, smart `H`/`L` that toggle between first/last-nonblank and 0/$ based on cursor position, `gh`/`gl` jumplist back/forward, `<Leader>k`/`<Leader>j` g;/g, through changelist, `U` → `<C-r>`, `<Leader>sd` diff-toggle across all windows.
These establish the non-plugin vim idioms the rest of the config stacks on top of — buffer/tab/window nav, smart line-edge motion, jumplist/changelist ergonomics.

## behavior/

**`autopair.lua` → nvim-autopairs + nvim-treesitter-endwise**
nvim-autopairs inserts matching brackets/quotes with `check_ts=true` so it respects treesitter contexts; custom rules add/remove a space pair `( | )` inside `()` / `[]` / `{}` and move the cursor past `)` when typing `)` in a space-padded pair; endwise auto-inserts `end` for Ruby/Lua/Bash block structures.
Together they handle closing character insertion so brace/space/end-keyword indentation "just works" while typing.
Contributes to a "type-forward" editing flow where you almost never type a closing bracket or `end` manually.

**`qol.lua`** — grab-bag of quality-of-life plugins:

  - **vim-pasta**: smart-indents pasted text to match surrounding indent; naive (no treesitter), so Python paste may still need `==`. Makes `p` / `P` produce correctly-indented blocks in most languages without `==`.
  - **karen-yank.nvim**: separates yank and delete/change registers so `d` doesn't overwrite the unnamed register. Lets you delete text and still paste what you yanked before — no macro gymnastics needed.
  - **yankbank-nvim** (+sqlite.lua): clipboard history persisted to sqlite, max_entries=10, `<Leader>sy` opens the picker. Gives you a persistent yank ring that survives restarts.
  - **snacks.nvim** (priority=9999, eager): enables `quickfile` + `bigfile`; indent guides with chunk (arrow `─`, only_current, priority 510/511) meant to skip `filetype_excludes` (filter is currently inverted — compares the excludes list against `buftype` instead of `filetype` and returns on-match; in practice the trailing `buftype == ''` check is what actually gates normal buffers); LSP file rename `<Leader>rf`; profiler toggles `<Leader>pt` / `<Leader>ph` / `<Leader>po`; buffer close group `<Leader>wq/wQ/wa/wA/wo/wO` using `snacks.bufdelete` so window layout is preserved. Indent context while typing + safe buffer closing that preserves splits — the backbone of the editing experience.
  - **auto-save.nvim**: 500ms-debounced autosave, condition skips `oil`/`oil_preview`, `<Leader>ota` toggles. Removes the need to ever type `:w` — text is always on disk for LSP/linters/tests/hot-reload.
  - **flatten.nvim**: opens files from nested `nvim` calls in the outer instance; `should_block` waits on `-b` flag; `post_open` hides toggleterm while blocking, sets current window for normal files, and for `gitcommit` schedules a `BufWritePost` buffer-delete; `block_end` toggles terminal back open. Lets you run `git commit` inside the toggleable terminal — edit the message in the parent session, write, and the terminal reopens automatically.
  - **mini.basics**: opinionated defaults — `win_borders='double'`, option-toggle prefix `<Leader>ot`, windows bindings on, alt-hjkl move, `relnum_in_visual_mode`. Baseline mappings/autocmds so the rest of the config only adds bespoke keys.
  - **mini.move**: move lines/selections with `Alt-hjkl`. Reorder lines and visual blocks without cut-and-paste.
  - **vim-sleuth**: detect `shiftwidth` / `expandtab` from file content. Drop into a foreign project and indent automatically matches.
  - **vim-tmux-navigator**: `<C-h/j/k/l>` and `<C-\>` traverse vim splits and tmux panes transparently; `VimEnter`/`VimLeave` autocmds set/unset tmux `@is_vim` option so tmux knows to hand off. Unified motion keys across the whole multiplexed environment.
  - **nvim-early-retirement**: auto-closes stale hidden buffers past `minimumBufferNum=6` with a notification. Buffer list stays lean — just keep opening files, stale ones evict themselves.
  - **ftmemo.nvim**: remembers manual filetype overrides per file, ignores `filetype_excludes`. `:set ft=bash` on an extensionless script sticks across reopens.

**`faster.lua`** — intentionally empty (faster.nvim commented out).
Placeholder file left in case a load-time speedup plugin is re-enabled.
No effect currently.

**`bullets.lua` → autolist.nvim** (bullets.vim kept commented as prior impl)
`ft=markdown/text/tex/plaintex/norg`; insert-mode `<CR>` and normal-mode `o`/`O` call `AutolistNewBullet`/`AutolistNewBulletBefore` so continuing a list just works; normal-mode `<CR>` and `<Leader>x` both call `AutolistToggleCheckbox` (normal `<CR>` also advances a line after toggling); `<C-r>` renumbers via `AutolistRecalculate`.
Type-forward list editing in markdown/text buffers — new bullets and checkbox toggles happen in-flow without reaching for a command.

**`marks.lua` → marks.nvim**
Adds signcolumn glyphs for each `m{a-z}` mark plus helpers for bookmarks/deletion; default setup.
Makes marks visible instead of invisible metadata — glance at the gutter to see what you've pinned.
Contributes to a "visual marks as labeled waypoints" workflow.

## bindings/

**`hints.lua` → which-key.nvim**
Popup that surfaces all `<Leader>…` chains after a brief delay; `icons.group='» '`, `layout.align='center'`.
Registers group labels so the popup is organized: Hydras, Find…, Select…, Global/Git…, Manage/Multicursor…, Jump…, Explore/Explain…, Test/Task…, Options… (with Toggles…), Replace/Request…, Debugging…, Hunk…, Project…, URL…, Quit/session…, Breakpoint…, Window/Buffer…; finishes by requiring `config.misc-keybinds`.
Turns the leader key into a navigable menu, and is the trigger that loads the core keymaps — so `<Space>` always opens to a labeled tree.

## ui/

**`animations.lua`** — two animation plugins:

  - **smear-cursor.nvim**: neovide-style cursor smear in the TUI using block glyphs, `cursor_color='#eb6f92'`, `legacy_computing_symbols_support=false`, `hide_target_hack=true`, `smear_bettween_buffers=false`, `trailing_stiffness=0.25`. Makes cursor motion visually traceable in plain terminals, not just neovide.
  - **mini.animate**: only `open` / `close` window animations enabled — cursor (smear-cursor), scroll (disabled for cmp sanity), resize (neovide) all off. Soft fade-in/out for popups and splits without slow-scroll nausea; cooperates with smear-cursor rather than conflicting.

**`breadcrumbs.lua` → dropbar.nvim**
Winbar breadcrumb showing the treesitter/LSP symbol path down to the cursor; `menu.preview=false`.
No custom keymaps — relies on dropbar defaults for clicking/navigating.
Always-on "where am I" indicator at the top of every buffer; pairs with `navbuddy` for actual navigation.

**`colorscheme.lua` → lush.nvim + theme stable + last-color + transparent**
Declares `lush.nvim` (not itself a theme, but colorscheme toolkit) with a dependency stable of onedarkpro, tokyonight (style=storm), zenbones (lightness='dim'), rose-pine (with custom highlight overrides for WinSeparator/CurSearch/Search/Visual), sonokai (default), habamax, nvimgelion, evangelion, rei, vim-cyberpunk, mfd; priority=1000 so it loads first; `last-color.nvim` recalls the last-used scheme on startup (fallback `sonokai`); `transparent.nvim` toggled via `<Leader>ott`.
Pick schemes via `<Leader>sc` (fzf-lua colorscheme picker); choice persists across restarts via `last-color`.
Supports a "cycle themes freely" workflow — the overrides on rose-pine and the dim/storm presets are pre-applied, so the picker always returns a polished result.

**`fold.lua`** — intentionally empty (UFO + fold-preview + FastFold all commented).
Note in file: "most situations are better solved by refactoring than folding."
Folds are deliberately disabled at the plugin level; `foldlevelstart=99` in `base_config` keeps everything unfolded.

**`goto-preview.lua` → detour.nvim + fzf-lua**
`gd` / `gt` / `gT` open LSP definition / typeDefinition / declaration in stacked detour float popups; `<Leader>fi` does the same for implementations; custom `pick_and_detour` uses `vim.lsp.buf_request_all` in parallel with a 200ms timer — if exactly one location resolves in that window, fzf is skipped and the detour opens directly; multiple results open the fzf picker (`async=true` to bypass the 5s sync block) with overridden `default` and `jump1_action` to route into a detour; inside a popup, `q` closes the top, `Q` closes the full stack, and `<CR>` closes the stack and edits the file at the popup's cursor position.
Produces recursive stacked previews where you drill from definition → definition without ever jumping the original window; only an explicit `<CR>` commits.
Central to a "peek deep into code" workflow that keeps the source buffer anchored.

**`highlights.lua`** — visual-highlight plugins:

  - **retrail.nvim**: tracks trailing whitespace with hl `DiffDelete`, filetype exclude list, `trim.auto=false`; `<Leader>gw` runs `:RetrailTrimWhitespace`. See leftover whitespace and clean on demand (autosave's pre-save hook already cleans silently on most saves).
  - **todo-comments.nvim** (+plenary): highlights and searches TODO/FIXME/NOTE/HACK/etc.; pattern tuned to optional colon. Trouble integration at `<Leader>ft` lets you grep-by-intent across the project.
  - **log-highlight.nvim**: syntax for `.log` files plus `messages`. Readable log buffers without manual `set ft=`.
  - **eyeliner.nvim**: highlights reachable `f`/`t` targets only while the motion is pending (`highlight_on_key=true`). See exactly which char to type for a quick `f`-jump without permanent visual noise.
  - **nvim-hlslens**: floating virt-text badge showing match count/position; `calm_down=true` so moving off dismisses; rebinds `n/N/*/#/g*/g#` to wrap in `hlslens.start()`. Know where you are in search results without losing incremental-search behavior.
  - **vim-illuminate** (+treesitter): underdots other occurrences of the word under cursor (`under_cursor=false`, `filetypes_denylist=excludes`, `IlluminatedWord*` groups set to `underdotted`). Skim variable usage across a file without typing a search.
  - **mini.cursorword**: plain highlight of word under cursor (default setup). Fast visual sibling to illuminate for short-range matching.
  - **visimatch.nvim**: highlights other occurrences of the current *visual selection* with `CursorLine`, `strict_spacing=true`. See duplicates while actively selecting a block without forming a search.
  - **modicator.nvim**: linenumber color reflects current mode; `show_warnings=false`; a `VimEnter` hook clears `MarkSignNumHL` so marks.nvim can't override modicator's mode-aware linenr color wherever a mark sits. Peripheral mode indicator — you know you're in insert without looking at the lualine.
  - **deadcolumn.nvim** (event=BufEnter): soft colorcolumn warning as you approach the limit (warning hlgroup=`Warning`/`background`). Subtle gradient hint without a hard vertical line.
  - **nvim-colorizer.lua**: inline color preview for `#hex`, `rgb()`, etc. See colors while editing CSS, themes, config palettes.

**`hover.lua` → hover.nvim (+urlpreview.nvim)**
hover.nvim (pinned to commit `140c4d0`): registers providers for LSP, DAP, diagnostic, dictionary; `K` triggers combined hover, `<M-K>` enters the hover window if it's valid so you can scroll inside; border=solid, title=true.
urlpreview.nvim: `<Leader>uu` fetches OG tags for the nearest URL and shows them in a float (auto_preview off for safety), `max_window_width=100`, border=solid.
Single key `K` shows the most-relevant info for whatever is under the cursor; `<Leader>uu` previews linked docs/issues without leaving the editor.

**`live-command.lua` → live-command.nvim**
Live preview for ex commands; registered `Norm = { cmd = 'norm', hl_range = { kind = 'visible' } }`.
File comment notes "doesn't really work in this setup yet" — planned rather than abandoned; intended to show ex-command effects while typing so you don't have to guess.
Parked until the integration issue (likely a noice/cmdline interaction) is resolved.

**`lualine.lua` → lualine.nvim (+scope.nvim)**
Global statusline (`globalstatus=true`, arrow separators): `a`=mode + toggleterm number, `b`=cwd folder + git branch + diff (added/modified/removed icons) + diagnostics (error/warn/info/hint icons, no insert update), `c`=noice search status, `x`=overseer tasks, `y`=encoding/fileformat/filetype/progress, `z`=location; tabline has buffers (with modified/alt/dir icons and mode-colored) on the left and tabs on the right; `scope.nvim` is set up so each tabpage has its own buffer list; `<Leader>wr` prompts `LualineTabRename`.
Turns each tab into an isolated workspace (scoped buffers), with one information-dense global bar.
Contributes to a "tabs as projects" workflow where `<S-Tab>` cycles between task-scoped buffer groups.

**`misc.lua`** — noice + edgy + context vt + helpview + menu + showkeys:

  - **noice.nvim** (+nui, v4): replaces cmdline/messages UI; cmdline view=`cmdline` with per-pattern icons for `:` / `/` / `?` / `:!` / lua / help; overrides `vim.lsp.util.convert_input_to_markdown_lines` / `stylize_markdown` and `cmp.entry.get_documentation` so LSP docs pretty-print; mini view 4s timeout; `<Leader>oH` opens `NoiceHistory`. Clean bottom-of-screen cmdline with syntax highlight appropriate to the command's language; LSP markdown no longer shows backslashes.
  - **edgy.nvim** (event=VeryLazy): docks known sidebar/panel filetypes to consistent positions — bottom: toggleterm 40% (filter excludes floats), OverseerOutput 20%, Trouble, dap-view 35%, help 30%, man 30%, qf; right: neo-tree 36, undotree 40%, diff 40%, grug 88, OverseerList 36, neotest-summary 36; animate off. Panels always open in the same place — consistent IDE-like layout regardless of which command opened them.
  - **nvim_context_vt**: virtual text at end of closing braces showing which block was closed; `prefix='󱞿 '`, `min_rows=7`, `priority=500`, `disable_ft=excludes`. Long functions/classes show their opening context where they close.
  - **helpview.nvim** (lazy=false, +treesitter): prettier rendering of `:help` buffers with real headings/folds. Makes `:help` readable without external docs.
  - **nvzone/menu** (+volt +minty): right-click / `<C-t>` context menu; replaces builtin PopUp; augments the default menu by inserting "Test Actions" (neotest run/run-file/run-last/debug-last/debug/debug-file/stop/toggle-summary/toggle-output) at slot 5 and "Breakpoint Actions" (toggle/conditional/logpoint/clear) at slot 6; the statuscol and gitsigns left-clicks also trigger it. GUI-style contextual actions over debugging/testing without leaving keyboard.
  - **nvzone/showkeys**: on-screen overlay of the last `maxkeys=5` keys; triggered by `:ShowkeysToggle`. Useful for demos/screencasts — viewers see the chord.

**`project.lua`** — session/dashboard/task stack:

  - **neovim-session-manager** (+plenary +overseer +scope pinned to `f8a6783`): per-cwd session autosave/load with scope integration; `AutoloadMode.CurrentDir`, ignores `~`, autosave only in existing sessions; `<Leader>pp`/`ps`/`pd` load/save/delete sessions, `<Leader>qs` saves current; autocmd saves scope state on `SessionSavePre`. Open nvim in a project and splits/buffers/tabs restore to last state.
  - **nvim-lastplace**: restore cursor to previous position when reopening; excludes gitcommit/gitrebase/svn/hgcommit plus `filetype_excludes`, opens folds. Reopen any file at the line you left.
  - **dashboard-nvim** (event=VimEnter, +web-devicons +projections +fzf-lua): hyper-theme greeter with week_header; shortcuts for Quit / Update (Lazy sync + TSUpdate) / dotfiles cd / Projects (session picker) / Find Directory (fzf-lua with `fd --type d`) / Find File (fzf-lua with `fd --no-ignore --hidden`) / New File; project list (limit 2), MRU (limit 3), random motd footer; `<Leader>qd` returns to dashboard by closing everything. Launching bare `nvim` gives a command-center screen to pick project/file instead of landing in an empty buffer.
  - **overseer.nvim** (pinned ^2.1.0, +nvim-dap): VSCode `tasks.json`-compatible task runner; strategy=toggleterm (open_on_start=false, auto_scroll); task_list `<C-hjkl>` keymaps cleared; bridges `dap.ext.vscode.json_decode` to overseer's json; `<Leader>tv` toggles task view, `<Leader>st` runs a task. Build/test tasks defined once and callable from keyboard or the context menu's Test Actions submenu.

**`quickfix.lua` → stevearc/quicker.nvim + kevinhwang91/nvim-bqf (+fzf)**
Both load on `ft=qf`. quicker exposes `R` (refresh qf from disk) and the file's `keys` block binds `<Leader>fq` → `quicker.toggle({focus=true})` (quickfix) and `<Leader>fQ` → `quicker.toggle({loclist=true, focus=true})`. nvim-bqf is set up with `auto_enable=true`, `auto_resize_height=true`, preview window height=9 (single border, wrap); filter bindings: `<Leader>f` fzffilter, `<Leader>n`/`<Leader>N` include/exclude filter; fzf picker bindings `ctrl-f`/`ctrl-b` preview page down/up, `ctrl-s` toggle-all, `│` delimiter for qf column parsing.
Turns the quickfix list into a modal, editable panel with preview and fuzzy filtering — the structural-editing flow (#9 in WORKFLOW.md) now extends into the qf buffer itself: edit matches in place, `R` to refresh, then write back to source files. Pairs with grug-far's "send to quickfix" exit path.

**`scrollbar.lua` → nvim-scrollbar (+hlslens +gitsigns)**
Side scrollbar with overlays: `show_in_active_only=true`, `hide_if_all_visible=true`, excluded_filetypes=`filetype_excludes`; handlers cursor/diagnostic/gitsigns/handle/search all enabled.
Diagnostic, gitsigns, and search handler modules are wired up via `require('scrollbar.handlers.diagnostic|gitsigns|search').setup()` in config.
Produces a mini-map-lite showing diagnostic positions, git hunks, and search matches alongside the main scroll indicator without a full minimap's rendering cost.

**`statuscol.lua` → statuscol.nvim (+nvzone/menu)**
`setup(...)` is wrapped in a `FileType` autocmd (bailing if filetype is in `filetype_excludes`) as a workaround — one-shot setup didn't stick for later-opened filetypes, so re-applying per-filetype is the fix; `relculright=true`; fillchars for foldopen/close/sep; segments ordered signs(catchall with maxwidth/colwidth 2) → lnum → gitsigns(namespace-filtered, width 1) → foldfunc; click handlers: left-click on `Lnum` runs `PBToggleBreakpoint` (persistent-breakpoints), left-click on gitsigns opens `menu.open('gitsigns')`.
Deterministic left-to-right gutter layout with actionable clicks.
Contributes to a GUI-ish gutter flow — click a line to toggle a breakpoint, click a gitsign to open a hunk action menu.

**`trouble.lua` → trouble.nvim (+web-devicons)**
Loads on `LspAttach`; `focus=true`; keys: `<Leader>ft` `TodoTrouble`, `gr` lsp_references, `<Leader>fc`/`<Leader>fC` incoming/outgoing calls, `<Leader>fd` buffer diagnostics, `<Leader>fD` workspace diagnostics. The old `<Leader>fq` quickfix binding is commented out — quickfix now lives in `ui/quickfix.lua` via quicker.nvim.
One window for navigating references, todos, call graphs, and diagnostics instead of juggling qf/loclist separately.
Complementary to fzf-lua's ad-hoc pickers and to quicker.nvim's editable qf — Trouble is the read-focused lens, quicker is the edit-focused one.

**`windows.lua`** — split/window management:

  - **windows.nvim** (+middleclass): auto-resizes focused window based on `winwidth=15`, `winminwidth=15`, `equalalways=false`, `autowidth.winwidth=1.5`, 150ms animation, filetype ignores; `<Leader>ww/we/wW/wh/wv` maximize / equalize / toggle-autowidth / maximize-horiz / maximize-vert. Biases screen real estate toward the current window automatically — no manual `<C-w>=` or `:resize`.
  - **winpick.nvim**: `<Leader>sw` labels visible windows and jumps on keypress; border=solid. Multi-split navigation without counting `<C-w>w` presses.
  - **colorful-winsep.nvim** (event=WinLeave): colored accent border around the focused split; single-border, animate disabled, 2-window custom arrow glyphs (`🮥`/`🮤`/`🮧`/`🮦`), excludes telescope/mason/lazy/WhichKey/dashboard/lspinfo. Stronger visual focus on the active split.

## tools/

**`buffer-switch.lua` → reach.nvim**
`<Tab>` opens `reach.buffers` (handle=dynamic, modified/alternate icons, depth-2 previous markers, `;`/`'` for splits, `<BS>` delete); a monkey-patched `reach.util.pgetcharstr` intercepts the first keypress — if it's `<Tab>`, it bypasses reach entirely and jumps to the MRU buffer (highest `lastused`, excluding current).
`<Tab><Tab>` ≈ "switch to last buffer" instantly; `<Tab>{label}` ≈ jump by label; anything else falls back to reach's normal picker.
Fast single-hand buffer switching with a built-in "most recent" shortcut — mimics `Cmd-Tab` app switcher behavior.

**`editing.lua`** — text-manipulation plugins:

  - **wildfire.nvim** (lazy=false, +treesitter): `<Leader><CR>` expands selection to the next treesitter node; filetype excludes applied. Grow selection by syntactic boundary instead of counting motions.
  - **treesj** (+treesitter): `<Leader>gs` toggles split/join of the current treesitter block; own default keymaps disabled. Flip inline ↔ multi-line for lists/objects/imports in one keystroke.
  - **mini.ai**: extended in/around text objects (arguments, brackets, function calls); default setup. Richer `di,` / `ca)` targets than the builtin text objects.
  - **nvim-various-textobjs** (event=VeryLazy, `useDefaults=true`): adds indent/subword/key/value/URL/number/etc. text objects. Fewer motions to grab structured pieces like "inner indent" or "the URL on this line."
  - **boole.nvim**: `<C-a>` / `<C-x>` increment/decrement with cycles; true↔false, yes↔no, and numeric. Toggle boolean-like values without retyping.
  - **Comment.nvim**: language-aware comment toggling; default setup (gcc/gc). Standard comment flow that respects treesitter embedded languages.
  - **search-replace.nvim**: `<Leader>rr` normal → `SearchReplaceSingleBufferCWord`, visual → yanks to `s` register then opens `%s/<Csr>//gc` with cursor positioned for typing; `<Leader>rs` → interactive open or visual `SearchReplaceWithinVisualSelection`. One-key "replace this identifier" without typing `:s/…`.
  - **nvim-surround** (+leap dep order): all default mappings disabled; remaps `gs` / `gss` / `gS` / `gSS` for surround-motion / surround-line / surround-motion-newlines / surround-line-newlines, `S` in visual, `dgs` / `cgs` / `cgS` delete/change. Custom `gs` prefix frees `s` and `ys` for leap and other uses.
  - **multicursor.nvim**: `<up>`/`<down>` add cursor above/below, `<c-n>` add at next match, `<c-s>` skip to next match, `<left>`/`<right>` rotate main cursor, `<c-q>` toggle disable/add, `<Leader>mx` delete, `<c-leftmouse>` mouse add, `<esc>` re-enable disabled cursors or clear and `nohl`, `<Leader>ma`/`ms`/`mm` align/split/match in selection; multicursor highlight links to Cursor/Visual. Edit multiple matching sites simultaneously without recording macros.
  - **undotree**: `<Leader>fu` opens, `undotree_WindowLayout=3`, focus on toggle. Navigate branching undo history that normal redo discards.

**`files.lua`** — file exploration:

  - **neo-tree.nvim** (+plenary +web-devicons +nui +treesitter): right-side tree with sources filesystem/buffers/git_status/document_symbols and a winbar source selector; `open_files_do_not_replace_types` list avoids overwriting terminal/trouble/qf/edgy panes; filesystem shows hidden files by default; custom icons for modified/git status; `<Leader>ee`/`ef`/`ej`/`eb`/`es` toggle / focus / reveal current / view buffers / view symbols. Tree sidebar that doubles as buffer/git/symbol browser — one pane, many lenses.
  - **lf.nvim** (+toggleterm): floating terminal embedding the `lf` file manager; `default_file_manager=true` (replaces netrw), single border; `<Leader>mf` opens at the current file or cwd. Full `lf` keybinds/image preview inside nvim for heavier file operations neo-tree doesn't cover.

**`fzf-lua.lua` → fzf-lua (+web-devicons)**
Fuzzy picker setup: winopts border=single, backdrop off; files previewer=bat; buffers `tab` and `default` actions both → `file_edit`, ignore_current_buffer=true; registered as `vim.ui.select` with adaptive height (0.3–0.7 based on item count, centered at `row=0.6`/`col=0.5`); global keymaps — `<Leader><Tab>` files (uses `fd --type f --no-ignore --hidden --follow --exclude {filter.getFilter()}`, vertical preview), `<Leader>fh` help tags, `<Leader>fS` workspace symbols, `<Leader>fb` buffer live-grep (vertical preview), `<Leader>sr` registers, `<Leader>ss` spell suggest (cursor-relative small popup), `<Leader>sl` filetype picker (small bottom-right), `<Leader>sb` git branches, `<Leader>sc` colorschemes (small bottom-right), `<Leader>ga` code actions (cursor-relative flex preview). `<Leader><Leader>` is now the unified palette (see `lua/palette.lua`).
Every popup has a deliberate geometry — spell/actions pop near the cursor, colorschemes/filetypes at bottom-right, global find-file centered with vertical preview.
Central fuzzy interface — files, symbols, actions, registers, colorschemes all share the same muscle memory; `vim.ui.select` integration means any code-action/prompt uses the same picker.

**`grug.lua` → grug-far.nvim** (v1, reads filter.lua)
Project-wide find/replace panel; `startInInsertMode=false`, `transient=true`, `q` closes in normal mode; default flags `--smart-case --no-ignore --hidden`; `<Leader>ff` opens with `filesFilter=!{filter.getFilter()}` (inverted — files matching the filter are excluded), `<Leader>fF` scopes to current file (`expand('%:.')`), `<Leader>fa`/`<Leader>fA` same two scopes but switches engine to `astgrep`. A `FileType grug-far` autocmd defers past grug-far's own keymap setup to rebind `<Leader>q` to "send matches to quickfix and close grug-far" — so results flow straight into quicker.nvim's editable qf.
Inline-editable preview buffer — type a replacement, see the diff, then sync.
Structured-refactor flow (rg for string, astgrep for AST), sharing the same persistent filter as the file picker and handing results off to the quickfix surface when you want to edit in place.

**`link-visitor.lua` → link-visitor.nvim**
`<Leader>uo` opens the nearest URL to cursor via `link-visitor.link_nearest` (system open).
No additional config.
Quick jump to docs or issue links in comments without manually selecting text.

**`macros.lua`** — empty (NeoComposer commented out).
Historically bound `m` to toggle record, `M` to play, picker via `<Leader>mm` etc.
No effect currently; the `q`/`<Leader>m*` namespace is free for other plugins.

**`motion.lua`** — cross-buffer movement:

  - **leap.nvim** (from codeberg mirror, +vim-repeat, lazy=false): `s` leap, `S` leap-from-window (cross-window), `gA` treesitter select, `ga` linewise + treesitter select; `set_repeat_keys('<enter>','<backspace>')` so the motion repeats; `preview_filter` excludes whitespace and middle-of-alpha so `foobar[baaz]` highlights only the useful targets; `LeapBackdrop` linked to `Comment`. Primary long-range motion — replaces `f{char}` when the target is past a few chars.
  - **treewalker.nvim** (cmd=Treewalker, +treesitter): `<M-H/J/K/L>` navigate AST siblings/children/parents/next, `<Leader>mh/mj/mk/ml` swap nodes in the same directions; highlight off for speed. Move between functions/arguments/blocks by structure, and reorder siblings in place.

**`navbuddy.lua` → nvim-navbuddy (+navic +nui)**
`<Leader>fs` opens a single-border, 80%-size nested symbol browser from LSP document symbols; `auto_attach=true`, LSP preference order from `config.sources.lsp`; custom icons for every symbol kind; `navic_silence=true` so attach errors don't notify.
Navigate the file's symbol tree (class → method → field) in a focused modal.
Pairs with dropbar's always-on breadcrumb: dropbar shows where you are, navbuddy lets you jump elsewhere structurally.

**`palette.lua`** — lazy spec entry that binds the command palette.
Merges into the existing `ibhagwan/fzf-lua` spec via lazy's multi-spec merge; uses `init` (runs at startup, before fzf-lua loads) to register `<Leader><Leader>` → `require('palette').open()`. The picker logic itself lives in `lua/palette.lua`.
Decoupling the keybind spec from the picker module lets the palette live next to other tools/ specs while keeping fzf-lua's load semantics unchanged.

**`pipe.lua` → pipe.nvim**
Pipe a buffer or selection through a shell command and receive the output back; default setup.
Invoked directly via the plugin's `:Pipe`-family ex commands — no custom keymap.
In-buffer data massage (sort, jq, awk, python one-liners) without `:!` piping quirks.

**`regex.lua` → hypersonic.nvim**
`<Leader>er` (normal or visual) opens a borderless float explaining the selected regex pattern in plain English.
`cmd='Hypersonic'`; no other config.
Select a gnarly regex, see what each group/assertion/quantifier does — great for understanding existing code.

**`stats.lua`** — vanity/analytics (complementary, different lenses):

  - **wrapped.nvim**: Spotify-Wrapped-style annual/summary coding stats panel; `<Leader>os` opens at height=0.9, caps plugins=300/plugins_ever=500/lines=100000. Retrospective summary lens — "what has my year looked like."
  - **triforce.nvim**: live coding profile view; `<Leader>oS`, notifications off. Present-tense profile lens — "how am I working right now" — sits alongside wrapped rather than overlapping.

**`suda.lua` → suda.vim**
`suda_smart_edit=1` — when you `:edit` a root-owned file, suda transparently switches to sudo.
No other config.
Open a system config, modify, `:w` will prompt for sudo without reopening the file.

**`symbol-rename.lua` → live-rename.nvim**
`<Leader>gr` calls `live-rename.rename({insert=true})` — opens insert mode at the symbol with all LSP reference sites showing live updates as you type.
`config=true` (default setup).
See every callsite update live as the new name is typed — no modal dialog, just edit.

**`tabout.lua` → tabout.nvim**
`ignore_beginning=false`, `act_as_tab=true` — Tab jumps out of closing pairs when the cursor is adjacent to one, and otherwise acts as a plain Tab (so indentation inside filled pairs still works); combined with autopairs, typing a closing bracket is almost never necessary.
Normal-case flow: open `(`, type args, Tab past `)`, continue — and inside a filled pair, Tab still indents.
Full "jump out of empty pairs + indent inside filled pairs" intent is now wired.

**`toggleterm.lua` → toggleterm.nvim**
`open_mapping='<C-Space>'` toggles the main floating/split terminal; `shade_terminals=false`; terminal-mode `<C-h/j/k/l>` move between windows; `<C-z>` exits to normal (terminal normal mode).
Overseer uses it as a strategy; flatten.nvim hides/reopens it around blocking edits.
Single terminal keybind that integrates with the task runner and nested-nvim workflow.

## integration/

**`completion.lua` → blink.cmp (+blink.compat +LuaSnip +friendly-snippets)**
Rust-backed completion; `preset='enter'` (enter accepts); `<C-k>` show or fallback; `<Tab>` accepts active snippet, selects next, or falls back; `<S-Tab>` backward snippet/select/fallback; completion list `preselect=false`; menu draws two columns (kind_icon + label) via colorful-menu.nvim, matched indices highlighted with bold `BlinkCmpLabelMatch`; documentation auto-shows, ghost_text on; sources lsp/lazydev/snippets/path/buffer (lazydev bridged via blink.compat with `group_index=0`); snippets preset=luasnip; signature off; fuzzy `prefer_rust_with_warning`; cmdline uses preset=cmdline with custom `<CR>` (accept if menu visible, else fallback) and `<Esc>` (cancel menu or feed `<C-c>`), ghost text off.
Enter-to-accept completion with live documentation, colorful semantic labels, and snippet-aware Tab — plus cmdline completion sharing the same engine.
Main typing-assist layer that every LSP in the config feeds into.

**`debugging.lua`** — DAP stack:

  - **nvim-dap-view** (lazy=false): modern replacement for dap-ui; `auto_toggle=false`, winbar sections sessions/threads/watches/exceptions/breakpoints/scopes/repl/console with controls; windows size 35%, terminal 50%; `<Leader>dv` toggles. Unified debug console window — appears automatically when a session starts (via `dap.listeners.before.launch.dap_view`).
  - **nvim-dap** (+treesitter +nvim-nio +mason-nvim-dap +persistent-breakpoints +overseer +hydra): DAP client; custom signs (breakpoint `●` pink, conditional `󱄶`, rejected, logpoint `󰚢` blue, stopped `` yellow); external terminal = tmux split-pane 30%; listens `before.launch` to open dap-view; persistent-breakpoints loaded on `BufReadPost`; mason-nvim-dap auto-installs from `config.sources.dap`; custom `debugpy` adapter at `$MASON/packages/debugpy/venv/bin/python` that enriches config with the detected `.venv`/`venv`/`env`/`.env` python path and forces `integratedTerminal`; Python launch config pre-defined; keys `<Leader>b{b/c/l/d}` for breakpoint toggle/conditional/logpoint/clear, `<Leader>d{d/p/c/C/s/r/f/j/l/h}` for start/pause/continue/continue-to-cursor/stop/restart/find-breakpoints/step-over/into/out; `<Leader>dm` opens a hydra "Debug control mode" with single-key `c/C/J/L/H` so you don't chord while stepping. Set breakpoints that persist across restarts, then step through code rapidly via the hydra.
  - **nvim-dap-repl-highlights** (+treesitter +dap): treesitter-based syntax in the DAP REPL. REPL output and input are readable.
  - **nvim-dap-virtual-text** (+dap +treesitter): inline virtual text showing variable values at their source lines; `virt_lines=true`. See variable state at call site, not just in the watch panel.

**`detect-language.lua` → detect-language.nvim (+treesitter)**
Detects filetype from content on `FileReadPost`; `<Leader>sL` manual trigger.
No other config.
Extensionless scripts get a filetype automatically, so syntax/LSP/formatters activate without manual `:set ft=`.

**`formatting.lua` → none-ls.nvim (+plenary +mason-null-ls +mason)**
Bridges non-LSP formatters/linters into the LSP format/code-action API; `null_ls.setup()`, then mason-null-ls with `ensure_installed=config.sources.formatter` and `automatic_installation=true`.
`<Leader>gf` (misc-keybinds) uses `vim.lsp.buf.format` which routes through null-ls for stylua/yamlfix/beautysh, and ruff/luacheck/eslint_d/shellcheck/shellharden run as diagnostics.
Keeps "format on command" flow consistent regardless of whether the underlying tool is an LSP or a classic formatter.

**`git.lua`** — git stack:

  - **gitlinker.nvim**: `<Leader>gl` open on remote, `<Leader>gL` copy remote permalink, `<Leader>gb` open blame, `<Leader>gB` copy blame permalink. Paste a line-link into chat/PR review with one keystroke.
  - **diffview.nvim**: `<Leader>gd` opens `DiffviewOpen`, `<Leader>gh` `DiffviewFileHistory`; `enhanced_diff_hl`, file_panel on right, merge tool `diff3_mixed`, view_enter/view_leave hooks disable/enable windows.nvim autowidth, `q` closes in view/file_panel/file_history. Review staged/unstaged hunks file-by-file before committing without auto-resize throwing off the layout.
  - **gitsigns.nvim**: signcolumn hunks (`┃` add/change/delete, `‾` topdelete, `~` changedelete); preview border=solid; `current_line_blame=true` with 1s delay formatted `"author • author_time:%R • summary"`; on_attach binds `]h`/`[h` next/prev hunk, `<Leader>hs/hr/hS/hu/hR/hp/hd` stage/reset/stage-buffer/unstage/reset-buffer/preview/toggle-deleted (plus visual `hs/hr` range stage/reset), `ih` hunk text object, `<Leader>Ob` toggle inline blame, `gb` `blame_line`. Micro-level git feedback inside the edit buffer — stage from the source window, never leave.
  - **blame.nvim**: `gB` toggle; `virtual_style='float'`, blame args `--color-by-age -CCC`; custom format function — hash (Comment), author (colored by hash), date, summary (colored by hash), with "Not Committed Yet" fallback. Heavy-duty blame with rename/copy tracking when gitsigns' line blame isn't enough.
  - **resolved.nvim** (+plenary, event=VeryLazy): shows current status of issue links in comments as virtual text at the end of the comment line. Know at a glance whether the TODO's linked issue is closed without switching to a browser.

**`hurl.lua` → hurl.nvim** — **vestigial, scheduled for removal.**
Historically ran `.hurl` HTTP tests directly from the buffer; `setup()` only, no bindings.
Safe to delete the file; nothing else in the config depends on it.

**`lazydev.lua` → lazydev.nvim**
`ft='lua'` only; library includes luv types at `${3rd}/luv/library` loaded when `vim.uv` is mentioned in a file.
Feeds blink.cmp's lua completion via blink.compat (see completion.lua).
Writing plugin config gets accurate completion/types for `vim.api`, `vim.uv`, etc. without manual luaCATS setup.

**`lsp.lua` → nvim-lspconfig (+mason +colorful-menu +navic +inlay-hints +insert-inlay-hints)**
Central LSP orchestrator; `LspAttach` autocmd currently a placeholder (for future buffer-local keymaps); `inlay-hints.setup()` (toggle `<Leader>it`); `insert-inlay-hints.setup({disabled_filetypes=excludes})` with keys `<Leader>ic` / `<Leader>il` / `<Leader>ia` / visual `<Leader>i` for closest/line/all/selection insertion; overrides `textDocument/hover` and `textDocument/signatureHelp` with `border='solid'`; requires `config.language-specific` (loading per-LSP settings for basedpyright, lua_ls, yamlls); loads VSCode snippets via `luasnip.loaders.from_vscode.lazy_load`; `nvim-navic` feeds dropbar/navbuddy breadcrumbs. (Also contains a stale duplicate `mason.setup()` + `<Leader>om` keymap — the canonical setup lives in `mason.lua`.)
LSP is the backbone every other integration plugs into — completion, navbuddy, inlay hints, diagnostics, formatting, debugging.
Special workflow: insert-inlay-hints lets you "commit" an inferred type annotation into the source, replacing the virtual hint with real text.

**`mason.lua`** — canonical installer management (lsp.lua has a stale duplicate of the mason setup block):

  - **mason.nvim**: `:Mason` UI for installing LSPs/DAPs/linters/formatters; `<Leader>om` opens it; `MasonUpdate` on build. One place to see/install/update every external binary the config depends on.
  - **mason-lspconfig.nvim** (+mason +nvim-lspconfig): bridges mason installs to lspconfig setup; `ensure_installed=config.sources.lsp`, `automatic_installation=true`. Add an LSP to `config.sources.lsp` → installed and auto-wired on next start.

**`testing.lua` → neotest (^5.13.4, +nvim-nio +plenary +FixCursorHold +treesitter +neotest-python)**
Universal test runner; adapters={neotest-python({dap={justMyCode=true,console='integratedTerminal'}})}; running animation glyphs, skipped icon, virtual_text status, signs on; keys `<Leader>tt` toggle summary, `<Leader>tr/tR` run cursor/file, `<Leader>tl/tL` last/debug-last, `<Leader>td/tD` debug cursor/file, `<Leader>ts` stop, `<Leader>to` toggle output panel; snacks keymap sets `q` to close in `neotest-output`/`neotest-output-panel` filetypes.
Runs tests with optional DAP strategy for step-through debugging; summary panel in the right edgy dock, output panel in bottom.
Same key prefix (`<Leader>t`) drives run, debug, and stop — and the menu.lua context menu surfaces them graphically too.

**`treesitter.lua`** — treesitter stack:

  - **nvim-treesitter** (branch=`main`): `ensure_installed=config.sources.treesitter`, `auto_install=true`, `indent={enable=true, disable={'python'}}` (Python uses vim-python-pep8-indent instead), highlight enabled with a guard that disables for files >1MB. Parser layer — everything downstream (text objects, context, indent, surround rules) sits on this.
  - **nvim-treesitter-textobjects** (branch=`main`, +treesitter): `move.set_jumps=true`, `select.lookahead=true`, selection_modes `@parameter.outer=v`, `@function.outer=V`, `include_surrounding_whitespace=false`; text objects `am`/`im` function, `ac`/`ic` class, `as` scope; movements `]m`/`[m` function, `]]`/`[[` class, `]o` loop, `]s` scope, `]z` fold, `]M`/`[M`/`][`/`[]` end variants, `]d`/`[d` conditional; `f`/`F`/`t`/`T` made repeatable via `ts_repeat_move.builtin_*_expr`. Navigate and select by language structure — one set of motions across Python, TS, Lua, etc.
  - **nvim-treesitter-context** (+treesitter): sticky header showing enclosing function/class; `max_lines=3`, `multiwindow=false`, `<Leader>otx` toggles, `UIEnter` autocmd re-enables after reopen. Always know which function you're in even when scrolled past its signature.

## integration/language-support/

**`csv.lua` → csvview.nvim**
Column-aligned CSV/TSV rendering in-place via `display_mode='highlight'`.
`<Leader>otS` toggles the view *and* flips `wrap` at the same time so aligned columns don't wrap mid-row.
Quick "make this CSV readable" flow without switching buffers or tools.

**`jq.lua` → jq.vim**
Syntax highlighting for `.jq` filter files.
No config.
Authoring complex jq filters in their own files gets syntax coloring.

**`markdown.lua`** — markdown editing stack:

  - **markdown.nvim** (ft=markdown, `opts={}`): editing helpers for markdown (bullet continuation, list handling). Baseline markdown QoL while typing.
  - **render-markdown.nvim** (event=FileType, +treesitter +web-devicons): live pretty rendering in buffer; `file_types={markdown,quarto,rmd}`, `render_modes={n,c,i}`, heading `width='block'` min 88 with block icons (`█`→`██████`) and `▔`/`▁` above/below, `border=true`; code `position='right'`, `language_pad=1`, `width='block'` min 88, `border='thick'`. Edit markdown in-place with rendered look — notes feel like Obsidian without leaving nvim.

**`python.lua` → vim-python-pep8-indent (lazy=false, +treesitter)**
PEP8-correct indent rules for Python; loads after treesitter so it wins over treesitter's indent.
No config.
Fixes Python continuation/hanging indent which treesitter handles poorly (hence `indent.disable={'python'}` in treesitter.lua).

**`quarto.lua` → quarto-nvim (+otter.nvim +treesitter +molten-nvim)**
Literate notebook editing for `.qmd`; `codeRunner={enabled=true, default_method='molten'}`.
otter bridges multiple language LSPs in the same buffer; molten runs cells via Jupyter.
Data-science notebooks with LSP inside code blocks and inline cell execution.

**`tcss.lua` → nvim-tcss**
Textual (TUI framework) CSS support; `config=true`.
No other config.
Syntax/highlighting when writing `.tcss` for Textual apps.

**`typescript.lua` → typescript-tools.nvim (+plenary +lspconfig)**
Native replacement for tsserver-via-lspconfig — communicates directly with tsserver for faster/richer features; `opts={}`.
Replaces the need to configure tsserver manually via lspconfig/mason.
TS/JS development feels more like VSCode's integrated ts-server without the extra bridge.

## config/language-specific/

**`init.lua`** — dispatcher loaded by `lsp.lua`.
Requires `config.language-specific.python`, `.lua`, `.yaml`. (`qml.lua` exists but is not loaded from here.)
Apply per-LSP settings once mason and lspconfig are both initialized.

**`python.lua` → basedpyright config**
`vim.lsp.config('basedpyright', ...)` with analysis settings (`autoSearchPaths`, `diagnosticMode='openFilesOnly'`, `typeCheckingMode='standard'`, `useLibraryCodeForTypes`) duplicated under both `python` and `basedpyright` keys; `before_init` uses plenary's Path to locate `{root}/.venv/bin/python` (or `Scripts/python.exe` on Windows) and writes that to `settings.python.pythonPath`.
Project-local venv detection happens automatically — no manual `pythonPath` per project.
Pairs with the custom `debugpy` adapter in `debugging.lua` which does the same venv resolution.

**`lua.lua` → lua_ls config**
`vim.lsp.config('lua_ls', ...)` with an `on_init` that clears `documentFormattingProvider` and `documentFormattingRangeProvider`.
Stylua (via none-ls) becomes the sole formatter.
Prevents the "two formatters fight over spacing" problem.

**`yaml.lua` → yamlls config**
`vim.lsp.config('yamlls', { settings.yaml.format.enable=false })`.
yamlfix (via none-ls) becomes the sole YAML formatter.
Same single-source-of-truth formatter approach as lua.lua.

**`qml.lua` → qmlls config**
Overrides `qmlls` command to `qmlls -E` (extended mode).
Not loaded by `config/language-specific/init.lua` — dormant unless required explicitly.
Ready if QML work resumes; currently inert.
