# MakeShiftArtist's Neovim Flake

A modular Neovim configuration built with Nix Flakes, `flake-parts`, and `nix-wrapper-modules`. This setup provides a wrapped Neovim package that can be used as a standalone package, a NixOS module, or a Home Manager module.

## Quick Start

Try the configuration immediately without installing it to your system profile:

```bash
nix run github:MakeShiftArtist/neovim-wrapped
```

## Features

- **Modular Design**: Uses `flake-parts` for a clean, maintainable flake structure.
- **nix-wrapper-modules**: Leverages `nix-wrapper-modules` to manage the Neovim environment and plugin wrapping logic.
- **Unified Modules**: Provides both NixOS and Home Manager modules that share the same underlying configuration.
- **Lua Integration**: A dedicated directory for Lua configuration, keeping editor logic separate from Nix boilerplate.

## Installation

### 1. NixOS (Flakes)

Add the flake to your inputs and import the module into your system configuration.

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvim-config.url = "github:MakeShiftArtist/neovim-wrapped";
  };

  outputs = { self, nixpkgs, nvim-config, ... }: {
    nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nvim-config.nixosModules.default
        { programs.neovim-wrapped.enable = true; }
        ./configuration.nix
      ];
    };
  };
}
```

### 2. NixOS (Channels / Non-Flake)

To use this configuration on a non-flake system, you can fetch the flake and access its modules. Note that your system must have `experimental-features = nix-command flakes` enabled for `getFlake` to work:

```nix
# configuration.nix
{ config, pkgs, ... }:
let
  # Fetches the flake and converts it to a standard nix object
  nvim-flake = builtins.getFlake "github:MakeShiftArtist/neovim-wrapped";
in
{
  imports = [
    nvim-flake.nixosModules.default
  ];

  programs.neovim-wrapped.enable = true;
}
```

### 3. Home Manager (Flakes)

If you manage your home environment with flakes, add the input and import the module.

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nvim-config.url = "github:MakeShiftArtist/neovim-wrapped";
  };

  outputs = { nvim-config, home-manager, ... }: {
    homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
      modules = [
        nvim-config.homeModules.default
        { programs.neovim-wrapped.enable = true; }
        ./home.nix
      ];
    };
  };
}
```

### 4. Home Manager (Traditional)

For standalone Home Manager users without a top-level flake:

```nix
# home.nix
{ config, pkgs, ... }:
let
  nvim-flake = builtins.getFlake "github:MakeShiftArtist/neovim-wrapped";
in
{
  imports = [
    nvim-flake.homeModules.default
  ];

  programs.neovim-wrapped.enable = true;
}
```

### 5. Remote Usage

You can run the configuration or enter a shell environment remotely:

```bash
# Run the main branch directly
nix run github:MakeShiftArtist/neovim-wrapped

# Use as a temporary shell tool
nix shell github:MakeShiftArtist/neovim-wrapped
```

## Repository Structure

- `flake.nix`: Entry point and flake-parts orchestration. Exposes the package and the NixOS and Home Manager modules.
- `modules/neovim.nix`: The `nix-wrapper-modules` config. Each Lua file in `modules/nvim/` is loaded by exactly one spec here, which also lists the plugins and packages that file needs. The specs are grouped into core, plugins and languages.
- `modules/program.nix`: The `programs.neovim-wrapped` module shared by the NixOS and Home Manager modules (see [Options](#options)).
- `modules/nvim/`: The Lua config.
  - `options.lua`: Editor options and basic autocommands.
  - `keymaps.lua`: Leader key and custom keybindings.
  - `languages/`: One file per language (Bash, Deno, JSON, Lua, Nix, Python, Rust, TypeScript, YAML), each setting up its language server.
  - `plugins/`: One file per plugin (blink.cmp, conform, LuaSnip, SchemaStore, Telescope, Treesitter, etc.).
- `devenv.nix`: Development environment, including the nixfmt and stylua pre-commit hooks.
- `.github/workflows/update-flake.yaml`: Nightly `flake.lock` update.

There's intentionally no `modules/nvim/init.lua`. The wrapper would run it implicitly before every spec, so `options.lua` is loaded by its own spec instead. `modules/nvim/` is also on the runtimepath, so avoid folder names that Neovim loads automatically, such as `plugin/`, `lsp/`, `ftplugin/` or `after/`. Files in them would run outside the specs.

## Configuration Defaults

By default the modules only install the wrapped package, as the `programs.neovim` package named `nvim`. Everything else is opt-in through the [options](#options) below:

- **Default editor and aliases**: off by default. Enable `defaultEditor`, `viAlias`, `vimAlias` and `vimdiffAlias` as needed.
- **Binary name**: `nvim`. Set `binName = "nvix"` to install it alongside another Neovim (see [Using `nvix` alongside another Neovim](#using-nvix-alongside-another-neovim)).
- **Lean environment**: `programs.neovim`'s Python3 and Ruby providers are disabled by default to reduce closure size and startup overhead. They're set with `lib.mkDefault`, like the forwarded options, so `programs.neovim.withPython3` and the rest can still be set directly.

## Options

The NixOS and Home Manager modules are configured through `programs.neovim-wrapped`:

```nix
programs.neovim-wrapped = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  settings.rust = {
    enable = true;
    toolchain.enable = true;
  };
};
```

| Option | Default | Description |
| --- | --- | --- |
| `enable` | `false` | Install the wrapped Neovim. |
| `binName` | `"nvim"` | Name of the executable. Any other name, such as `"nvix"`, installs it alongside another Neovim. See below. |
| `defaultEditor` | `false` | Set it as the default editor, using the `EDITOR` environment variable. |
| `viAlias` | `false` | Make `vi` run it. |
| `vimAlias` | `false` | Make `vim` run it. |
| `vimdiffAlias` | `false` | Make `vimdiff` run it in diff mode (`-d`). |
| `settings.rust.enable` | `true` | Rust language support: rust-analyzer, clippy checks and formatting with rustfmt. |
| `settings.rust.toolchain.enable` | `false` | Bundle a complete Rust toolchain. See below. |
| `package` | read-only | The resulting Neovim package, built with these settings. |

When named `nvim`, `defaultEditor` and the aliases are passed on to `programs.neovim` as defaults, so you can also set `programs.neovim.viAlias` and the others directly. NixOS' `programs.neovim` has no `vimdiffAlias`, so on NixOS this module provides it.

### Using `nvix` alongside another Neovim

To keep a separate `nvim` (for example a stock one from `programs.neovim`) and use this configuration as `nvix`:

```nix
programs.neovim-wrapped = {
  enable = true;
  binName = "nvix";
};

# Optional: your other Neovim, which keeps the `nvim` name
programs.neovim.enable = true;
```

With any name other than `nvim`, the package is installed on its own (`environment.systemPackages` on NixOS, `home.packages` with Home Manager) instead of through `programs.neovim`, and only the renamed executables are installed (`nvix`, `nvix-node`, ...). `defaultEditor` and the aliases still work and point to `nvix`, so leave them off if your other Neovim should keep `EDITOR`, `vi` and `vim`.

### Rust toolchain

By default only `rust-analyzer` is installed, and the toolchain is expected to come from the project, through a dev shell or rustup.

Enable `settings.rust.toolchain.enable` to bundle a complete toolchain, so Rust works in any project, even without a dev shell:

- `cargo` and `rustc`, which rust-analyzer needs to load workspaces and run build scripts and proc-macros
- `clippy`, used by rust-analyzer's check command
- `rustfmt`, the formatter
- a C linker for build scripts and proc-macros
- the standard library sources, used only when the active toolchain doesn't ship its own

This adds about 2 GiB to the package, which is why it's off by default. A project's own toolchain still takes precedence when one is on `PATH`.

## Acknowledgments

- [BirdeeHub/nix-wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules)
- [hercules-ci/flake-parts](https://github.com/hercules-ci/flake-parts)
