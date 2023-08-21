# TODO

Things this repo needs, basically.

## NVIM

The basic plan is to replace VSCode with neovim, so, important functionality:

- [x] Syntax Highlighting
  - [x] Better dimming, etc for unused/etc
  - [x] Italics, bold, etc?
- [-] Intellisense (type-checking, etc) 
  - [ ] auto docstring?
- [x] Code completion (From file and intellisense, etc) 
- [-] Debugging 
  - [ ] Breakpoints, inspection
  - [ ] Possible vscode debug config support?
  - [-] vscode task support? (See vs-tasks.nvim for this and launch support)
  - [ ] javascript/other profiling
- [x] File Tree 
- [x] Fuzzy file jumping 
- [x] Project management (open a given set of files, remember previously-open files) 
- [x] File tabs 
- [x] Autoformatting 
- [ ] Intelligent indenting on paste 
- [x] Toggleable terminal 
- [x] Remove trailing spaces on exit insert mode 
- [x] Interactive git blame/figure out where a change came from 
- [x] Command palette 
- [x] LSP notifications 
- [x] Theme manager/switcher 
- [x] Autosave 
- [x] Sensible folding with obvious markers, mouse-support? 
- [x] lazygit/further git integration 
- [ ] connect to docker container and lazydocker? 
- [ ] Jupyter/similar 
- [x] TODO highlighting/overview 
- [x] Trouble: list all diagnostics (maybe TODO support?) 
- [x] Tab management keybinds/different buffer/tab line 
- [ ] Disable highlighting for extremely large files 
- [x] Fix errors coming from treesitter-indent when switching files 
- [ ] Fix statuscol diagnostics click action (remove border, make it stay until cursormove) 
- [ ] Fix rename symbol jumping up in document when writing 
- [x] Fix barbecue not actually getting LSP-context 
- [ ] Fix ctrl-hjkl when in insert mode


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
- [-] Break up some of the larger configs into folders 
- [x] Keep lualine on bottom regardless of window? 
- [x] Fix \<C-v\> opening telescope search vertical (currently just pastes) 
- [x] menu to open Lazy, Mason, other config stuff 
- [ ] Fix IncRename: needs to ensure diagnostic float is hidden/paused 
- [ ] Add more signature support somehow (e.g. typescript signatures on variables in bte) 
- [ ] Code hints not really displaying, might need above fix first ^ 
- [x] change nvim-tree icons for git to make more sense 
- [x] ensure dashboard loads after projections and legendary 
- [x] completely redo the project/session system to something simpler and more consistent 
- [ ] allow buffer closing from tab switch menu 
- [ ] add a statusline sneak indicator

And, after all this, the obvious way to destroy all my time:

- [ ] A stroll down the entirety of [Awesome-neovim](https://github.com/rockerBOO/awesome-neovim)

## Package Install Automation

- [ ] Automatically installs desired packages

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

- [ ] Fix tab spacing when firefox goes into narrow mode
