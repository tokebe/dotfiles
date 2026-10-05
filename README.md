# Dotfiles

Welcome to my dotfiles. Like any user, my setup is eclectic and idiosyncratic at best,
so bear with me.

## Installation

My dotfiles are managed using a custom set of python modules. Probably overcomplicated,
but it suits my use-case. Bear with me if you're trying to adapt it to your own setup.

### Quick installation

To bootstrap a new system, use one of the following commands:

`curl`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tokebe/dotfiles/main/bootstrap)"
```

`wget`:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/tokebe/dotfiles/main/bootstrap)"
```

### Normal Installation

Clone the repo:

```bash
git clone https://github.com/tokebe/dotfiles
```

Install:

```bash
cd dotfiles && ./bootstrap
```

## Design

My dotfiles use a custom `eclectic-dots` python orchestrator to handle most of the logic.
The logic they implement is fairly simple, covering 5 core steps (though the first 3 bundle together):

- Link any configured files from the dotfiles repo to their configured locations.
  - (before linking) Create any configured directories, if they don't exist.
  - (before linking) Clean up any dead symlinks in configured directories, provided they point to the dotfiles repo.
- Install any configured software
- Update any configured package managers

Different systems require different config and software, though, so there's also a profile system.
Profiles each can specify the same set of steps above. They behave as such:

- The default profile is always active.
- Secondary profiles are activated based on their configured conditions.
- Overlaps of profiles are resolved by profile priority, where lower priority goes first and higher overrides.

Package installation is handled by a set of shims which enable scripting around guaranteed behaviors:

- detect: Detect that the package manager is active on the present system.
- refresh (optional): Refresh package indices.
- list_installed (optional): List presently-installed packages, so we can skip them to save time.
- install: Install a given list of packages, ignoring individual failures, unless given a single package.
- upgrade: Upgrade all installed packages.
- check: Return a count of upgradeable packages.

Finally, there are hooks, which allow running arbitrary scripts in-between steps (or their stages):

- before/after
- Event: (one of the 3 primary step groups Link/Install/Update)
- Stage: For link: specifically the create/clean/link stages. For install/update, each package manager.

Package shim and hook commands are all run within bash for full bash scripting/environment.
Every hook, as well as every link config, is given the cwd of its profile directory.

## Acknowledgements

Anyone who deserves thanking, they'll go here.

- Initial Nvim config based around
  [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- Dotfiles workflow inspired by [dotbot](https://github.com/anishathalye/dotbot)
