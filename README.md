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

- `flake.nix`: Entry point and flake-parts orchestration.
- `modules/neovim.nix`: The Nix wrapper module that bridges Nix and Neovim.
- `modules/nvim/`:
  - `init.lua`: Core Neovim initialization.
  - `lsp.lua`: Language Server Protocol configurations.
  - `keymaps.lua`: Custom keybindings.
  - `plugins/`: Individual plugin configurations (Blink, Telescope, Treesitter, etc.).
- `devenv.nix`: Development environment configuration.

## Configuration Defaults

The modules provided by this flake automatically apply the following settings:

- **Binary Name**: The executable is named `nvix` (to avoid conflicts with standard `nvim`).
- **Default Editor**: Set to true via `EDITOR` environment variable.
- **Aliases**: `vi`, `vim`, and `vimdiff` are linked to the wrapped `nvix` package.
- **Lean Environment**: Python3 and Ruby providers are disabled by default to reduce closure size and startup overhead.

## Options

The NixOS and Home Manager modules are configured through `programs.neovim-wrapped`:

```nix
programs.neovim-wrapped = {
  enable = true;
  settings.rust = {
    enable = true;
    toolchain.enable = true;
  };
};
```

| Option | Default | Description |
| --- | --- | --- |
| `enable` | `false` | Install the wrapped Neovim (through `programs.neovim`) and make it the default editor. |
| `settings.rust.enable` | `true` | Rust language support: rust-analyzer, clippy checks and formatting with rustfmt. |
| `settings.rust.toolchain.enable` | `false` | Bundle a complete Rust toolchain. See below. |
| `package` | read-only | The resulting Neovim package, built with these settings. |

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
