# TODO

Things this repo needs, basically.

## NVIM

The basic plan is to replace VSCode with neovim, so, important functionality:

- [X] Syntax Highlighting
  - [X] Better dimming, etc for unused/etc
  - [X] Italics, bold, etc?
- [-] Intellisense (type-checking, etc)
  - [ ] auto docstring?
- [X] Code completion (From file and intellisense, etc)
- [-] Debugging
  - [ ] Breakpoints, inspection
  - [ ] Possible vscode debug config support?
  - [-] vscode task support? (See vs-tasks.nvim for this and launch support)
  - [ ] javascript/other profiling
- [X] File Tree
- [X] Fuzzy file jumping
- [X] Project management (open a given set of files, remember previously-open files)
- [X] File tabs
- [X] Autoformatting
- [ ] Intelligent indenting on paste
- [ ] Toggleable terminal
- [X] Remove trailing spaces on exit insert mode
- [ ] Interactive git blame/figure out where a change came from
- [X] Command palette
- [X] LSP notifications
- [X] Theme manager/switcher
- [X] Autosave
- [X] Sensible folding with obvious markers, mouse-support?
- [ ] lazygit/further git integration
- [ ] connect to docker container and lazydocker?
- [ ] Jupyter/similar
- [ ] TODO highlighting/overview
- [ ] Trouble: list all diagnostics (maybe TODO support?)
- [ ] Tab management keybinds/different buffer/tab line

And also the random notes for smaller things:

- [X] Markdown auto-continuing bullets, etc. (fix bullets or vim-markdown)
- [ ] re-enable luasnip jumping but fix the jumpback issue
- [X] Markdown preview (use hologram and glow?)
- [ ] Wrap before minimap
- [X] Don't auto-pair with a character directly in front
- [X] A theme that is good
- [X] Don't highlight trailing spaces in which-key window
- [X] Fancier look for telescope
- [X] Move all keymaps to legendary if feasible
- [ ] See if navbuddy can auto-select the first lsp or something
- [-] Break up some of the larger configs into folders
- [X] Keep lualine on bottom regardless of window?
- [ ] Fix \<C-v\> opening telescope search vertical (currently just pastes)
- [X] menu to open Lazy, Mason, other config stuff
- [ ] Fix IncRename: needs to ensure diagnostic float is hidden/paused
- [ ] Add more signature support somehow (e.g. typescrip signatures on variables in bte)
- [ ] Code hints not really displaying, might need above fix first ^
- [ ] change nvim-tree icons for git to make more sense
- [X] ensure dashboard loads after projections and legendary

And, after all this, the obvious way to destroy all my time:

- [ ] A stroll down the entirety of [Awesome-neovim](https://github.com/rockerBOO/awesome-neovim)

## Package Install Automation

- [ ] Automatically installs desired packages

Require the following:

- unzip
- ripgrep
- fzf
- fd
  - link properly on ubuntu using `ln -s $(which fdfind) ~/.local/bin/fd`
- ranger
- zsh
- lazygit
- lazydocker
- neofetch
- btop
- luarocks
- latest lua
- cmake


## Iosevka

- [ ] Automatically installs patched custom Iosevka

## Firefox

- [ ] Fix tab spacing when firefox goes into narrow mode
