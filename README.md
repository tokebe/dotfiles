# Dotfiles

Welcome to my dotfiles. Like any user, my setup is eclectic and idiosyncratic at best,
so bear with me.

## Installation

My dotfiles are managed using a custom set of python modules. Probably overcomplicated,
but it suits my use-case. Bear with me if you're trying to adapt it to your own setup.

### Quick installation

To boostrap a new system, use the following command:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/tokebe/dotfiles/main/bootstrap)"
```

### Normal Installation

Clone the repo:

```bash
git clone https://github.com/tokebe/dotfiles
```

Install:

```bash
cd dotfiles && bootstrap
```

## Acknowledgements

Anyone who deserves thanking, they'll go here.

- Initial Nvim config based around
  [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- Dotfiles workflow inspired by [dotbot](https://github.com/anishathalye/dotbot)
