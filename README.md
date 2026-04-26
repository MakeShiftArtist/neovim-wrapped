# MakeShiftArtist's Neovim Flake

A modular Neovim configuration built with Nix Flakes, flake-parts, and nix-wrapper-modules. This setup provides a wrapped Neovim package that can be used as a standalone package, a NixOS module, or a Home Manager module.

## Quick Start

Run the configuration directly without permanent installation:

```bash
nix run github:MakeShiftArtist/your-repo-name
```

## Features

* **Modular Design**: Uses `flake-parts` for a clean, maintainable flake structure.
* **nix-wrapper-modules**: Leverages `nix-wrapper-modules` to manage the Neovim environment and plugin wrapping logic.
* **Unified Modules**: Provides both NixOS and Home Manager modules that share the same underlying configuration.
* **Lua Integration**: A dedicated directory for Lua configuration, keeping editor logic separate from Nix boilerplate.

## Installation

### Home Manager

Add the flake to your inputs and import the module:

```nix
{
  inputs = {
    nvim-config.url = "github:MakeShiftArtist/your-repo-name";
  };

  outputs = { self, nvim-config, ... }: {
    homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
      modules = [
        nvim-config.homeModules.default
        ./home.nix
      ];
    };
  };
}
```

### NixOS

Add the flake to your system configuration:

```nix
{ inputs, ... }: {
  imports = [
    inputs.nvim-config.nixosModules.default
  ];
}
```

## Repository Structure

* `flake.nix`: Entry point and flake-parts orchestration.
* `modules/neovim.nix`: The Nix wrapper module that bridges Nix and Neovim.
* `modules/nvim/`:
    * `init.lua`: Core Neovim initialization.
    * `lsp.lua`: Language Server Protocol configurations.
    * `keymaps.lua`: Custom keybindings.
    * `plugins/`: Individual plugin configurations (Blink, Telescope, Treesitter, etc.).
* `devenv.nix`: Development environment configuration.

## Configuration Defaults

The modules provided by this flake automatically apply the following settings:

* **Default Editor**: Set to true.
* **Aliases**: `vi`, `vim`, and `vimdiff` are linked to the wrapped Neovim package.
* **Lean Environment**: Python3 and Ruby providers are disabled by default to reduce closure size and startup overhead.

## Acknowledgments

* [BirdeeHub/nix-wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules)
* [hercules-ci/flake-parts](https://github.com/hercules-ci/flake-parts)
