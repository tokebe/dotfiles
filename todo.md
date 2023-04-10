# TODO

Things this repo needs, basically.

## NVIM

The basic plan is to replace VSCode with neovim, so, important functionality:

- [-] Syntax Highlighting
  - [ ] Rainbow indent and brackets?
  - [ ] Better dimming, etc for unused/etc
  - [ ] Italics, bold, etc?
- [-] Intellisense (type-checking, etc)
  - [ ] auto docstring?
- [X] Code completion (From file and intellisense, etc)
- [-] Debugging
  - [ ] Breakpoints, inspection
  - [ ] Possible vscode debug config support?
  - [-] vscode task support? (See vs-tasks.nvim for this and launch support)
  - [ ] javascript/other profiling
- [ ] File Tree
- [X] Fuzzy file jumping
- [ ] Project management (open a given set of files, remember previously-open files)
- [ ] File tabs
- [-] Autoformatting
- [ ] Intelligent indenting on paste
- [ ] Toggleable terminal
- [X] Remove trailing spaces on exit insert mode
- [ ] Interactive git blame/figure out where a change came from
- [-] Command palette
- [X] LSP notifications
- [ ] Theme manager/switcher
- [X] Autosave
- [ ] CTRL-D multi-cursor with live edit behavior
- [ ] Sensible folding with obvious markers, mouse-support?
- [ ] lazygit/further git integration
- [ ] connect to docker container and lazydocker?
- [ ] Jupyter/similar
- [ ] TODO highlighting/overview
- [ ] Trouble: list all diagnostics (maybe TODO support?)

And also the random notes for smaller things:

- [X] Markdown auto-continuing bullets, etc. (fix bullets or vim-markdown)
- [ ] re-enable luasnip jumping but fix the jumpback issue
- [X] Markdown preview (use hologram and glow?)
- [ ] Wrap before minimap
- [X] Don't auto-pair with a character directly in front
- [X] A theme that is good
- [X] Don't highlight trailing spaces in which-key window
- [ ] Fancier look for telescope
- [ ] move all keymaps to legendary if feasible
- [ ] See if navbuddy can auto-select the first lsp or something

## Package Install Automation

- [ ] Automatically installs desired packages

Require the following:

- unzip
- ripgrep
- fzf
- fd

## Iosevka

- [ ] Automatically installs patched custom Iosevka
