# TODO

Things this repo needs, basically.

## ZSH Revamp

- NO CONFIG FRAMEWORK
- [antidote](https://antidote.sh/) for plugin mangement
- Fzf integration for file completion, command history
- A bunch of plugins, basically
- P10k with highly custom config for prompt
- Break files up for easier organization (variables, aliases, plugins, config)
- magic-enter to display a dashboard
- tab-enter to fzf file to edit with nvim/open with selector (gum?)?

## NVIM

Running TODO list:

- [x] ctrl-hl to move by one word in insert mode, alt-left/right to do the same?
- [ ] Jupyter/similar (probably something along the lines of magma, etc.)
- [x] Add a configurable default-exclude list for searches, editable through some \<Leader>o command
  - [ ] Now make it a robust plugin for others to use
- [ ] Better control of edgy windows--hydra to resize or something? Send to buffer?
- [ ] More snippets for different languages
- [x] Debugging
  - [ ] A solid control scheme
  - [x] Breakpoints, inspection
  - [ ] Persistent breakpoints (Just set up breakpoint keys using persistent-breakpoints commands)
  - [x] Possible vscode debug config support?
    - [x] Figure out how to show all tasks regardless of current file
  - [x] vscode task support? (See vs-tasks.nvim for this and launch support)
  - [x] javascript/other profiling
  - [x] fix statuscol -- stopped info not showing in own col
  - [x] toggle key for swapping term/repl
  - [x] maybe launch in tmux pane and then attach to (this would be incredibly complicated)?
  - [x] kill process on debug stop
- [ ] Fix overseer output not showing errors
- [ ] Prevent unnamed buffer on all buffers closed -- show file finder instead
- [ ] better quick fix management
- [ ] Fix visual-paste yanking replaced text
- [ ] Disable diagnostics on insert?
- [ ] Live file running for quicker iteration
- [x] Fix auto-indent in python files when on line > ~300
- [x] dressing.nvim -> snacks

## Other
