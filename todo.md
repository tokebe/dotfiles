# TODO

Things this repo needs, basically.

## NVIM

Running TODO list:

- [x] Syntax Highlighting
  - [x] Better dimming, etc for unused/etc
  - [x] Italics, bold, etc?
- [x] Intellisense (type-checking, etc)
- [x] Code completion (From file and intellisense, etc)
- [x] File Tree
- [x] Fuzzy file jumping
- [x] Project management (open a given set of files, remember previously-open files)
- [x] File tabs
- [x] Autoformatting
- [x] Intelligent indenting on paste
- [x] Toggleable terminal
- [x] Remove trailing spaces on exit insert mode
- [x] Interactive git blame/figure out where a change came from
- [x] Command palette
- [x] LSP notifications
- [x] Theme manager/switcher
- [x] Autosave
- [x] Sensible folding with obvious markers, mouse-support?
- [x] lazygit/further git integration
- [x] TODO highlighting/overview
- [x] Trouble: list all diagnostics (maybe TODO support?)
- [x] Tab management keybinds/different buffer/tab line
- [x] Disable highlighting for extremely large files
- [x] Fix errors coming from treesitter-indent when switching files
- [x] Fix barbecue not actually getting LSP-context
- [x] Inline markdown preview?
- [x] Fix fzf-lua using winopts from spelling/code actions for project selector
- [x] Automatic multiline comment continuation in js/ts
- [x] Better macro controls, using composer or something?
- [x] REST client with better workflow than current
- [x] Reorganize all the plugins
- [x] Quick switch to normal mode from terminal mode
- [ ] Fix rename symbol jumping up in document when writing
- [ ] Fix ctrl-hjkl when in insert mode
- [ ] Redo tmux setup to be simpler + nvim-compatible
- [ ] connect to docker container and lazydocker? (see https://github.com/jamestthompson3/nvim-remote-containers)
- [ ] Jupyter/similar (probably something along the lines of magma, etc.)
- [x] Add a configurable default-exclude list for searches, editable through some \<Leader\>o command
  - [ ] Now make it a robust plugin for others to use
- [ ] Persistent syntax/language setting per file (may have to make own plugin)
- [ ] Better control of edgy windows--hydra to resize or something? Send to buffer?
- [x] More snippets for different languages
- [ ] auto docstring: see vim-doge
- [x] Debugging
  - [x] Breakpoints, inspection
  - [x] Possible vscode debug config support?
    - [ ] Figure out how to show all tasks regardless of current file
  - [x] vscode task support? (See vs-tasks.nvim for this and launch support)
  - [x] javascript/other profiling
- [ ] Fix IncRename: needs to ensure diagnostic float is hidden/paused
- [x] Test file managers to replace ranger, then integrate with neovim
  - [ ] It's gonna be nnn with a bunch of setup >.<
- [ ] Acquire more colorschemes
- [x] Auto-backup lockfile
- [ ] Re-make hover.lua but just using a custom nui setup
- [ ] Fix fzf switcher being unable to distinguish between multiple unnamed buffers
- [ ] Add keybinds for toggling diff on two split files
- [ ] Fix `x` sometimes deleting, sometimes cutting
- [x] Fix Fzf perf when in large directory -- async or timeout?
- [ ] Fix overseer output not showing errors
- [ ] Improved debug experience -- sourcemaps, scopes indentation?
- [ ] Incorporate nvim-treesitter-textobjects
- [ ] Format visual selection by (choose language), for stuff such as Hurl files
- [ ] Automatic .yamllint and other configs to their respective linters/formatters/etc

And also the random notes for smaller things:

- [x] Markdown auto-continuing bullets, etc. (fix bullets or vim-markdown)
- [x] re-enable luasnip jumping but fix the jumpback issue
- [x] Markdown preview (use hologram and glow?)
- [x] Don't auto-pair with a character directly in front
- [x] A theme that is good
- [x] Don't highlight trailing spaces in which-key window
- [x] Fancier look for telescope
- [x] Move all keymaps to legendary if feasible
- [x] See if navbuddy can auto-select the first lsp or something
- [x] Keep lualine on bottom regardless of window?
- [x] Fix \<C-v\> opening telescope search vertical (currently just pastes)
- [x] menu to open Lazy, Mason, other config stuff
- [x] Add more signature support somehow (e.g. typescript signatures on variables in bte)
- [x] Code hints not really displaying, might need above fix first ^
- [x] change nvim-tree icons for git to make more sense
- [x] ensure dashboard loads after projections and legendary
- [x] completely redo the project/session system to something simpler and more consistent
- [x] allow buffer closing from tab switch menu

And, after all this, the obvious way to destroy all my time:

- [x] A stroll down the entirety of [Awesome-neovim](https://github.com/rockerBOO/awesome-neovim)

## Package Install Automation

- [x] Automatically installs desired packages

Require the following:

- [ ] unzip
- [ ] ripgrep
- [ ] fzf
- [ ] fd
  - [ ] link properly on ubuntu using `ln -s $(which fdfind) ~/.local/bin/fd`
- [ ] ranger
- [ ] zsh
- [ ] lazygit
- lazydocker
- [ ] neofetch
- [ ] btop
- [ ] luarocks
- [ ] latest lua
- [ ] cmake
- [ ] tldr

macos specific:

- [ ] macos specific, python: use `ln -sf "$(brew --prefix)/bin/python"{3,}` to make python work
- [ ] coreutils

old ubuntu (such as wsl):

- [ ] manual install lsd
- [ ] manual install ccat

Things to do:

- [ ] make sure that nvim isn't reinstalled if it's the latest release version

## Iosevka

- [x] Automatically installs patched custom Iosevka

## Firefox

- [ ] Fix the layout in general
