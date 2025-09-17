# TODO

Things this repo needs, basically.

## NVIM

Running TODO list:

- [ ] ctrl-hl to move by one word in insert mode, alt-left/right to do the same?
- [ ] Jupyter/similar (probably something along the lines of magma, etc.)
- [x] Add a configurable default-exclude list for searches, editable through some \<Leader>o command
  - [ ] Now make it a robust plugin for others to use
- [ ] Better control of edgy windows--hydra to resize or something? Send to buffer?
- [ ] More snippets for different languages
- [ ] Debugging
  - [x] Breakpoints, inspection
  - [ ] Persistent breakpoints (requires manual implementation, see https://github.com/mfussenegger/nvim-dap/issues/198)
  - [x] Possible vscode debug config support?
    - [x] Figure out how to show all tasks regardless of current file
  - [x] vscode task support? (See vs-tasks.nvim for this and launch support)
  - [x] javascript/other profiling
  - [x] fix statuscol -- stopped info not showing in own col
  - [x] make debugging run in a hydra for ease-of-use
  - [ ] toggle key for swapping term/repl
  - [ ] maybe launch in tmux pane and then attach to (this would be incredibly complicated)?
  - [x] kill process on debug stop
- [ ] Fix overseer output not showing errors
- [x] Automatic .yamllint and other configs to their respective linters/formatters/etc
- [x] restart LSP after language changed
- [ ] Prevent unnamed buffer on all buffers closed -- show file finder instead
- [ ] better quick fix management
- [ ] Fix visual-paste yanking replaced text
- [ ] Disable diagnostics on insert?
- [ ] Live file running for quicker iteration
- [x] Fix visual highlight being set to wrong highlight
- [x] Better jumplist handling (portal's cool but bindings are so-so)

## Iosevka

## Other

- [x] migrate from pip/pipx/pyenv to uv/direnv
