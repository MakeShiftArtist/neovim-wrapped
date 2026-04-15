{
  description = ''
    Uses flake-parts to set up the flake outputs:

    `wrappers`, `wrapperModules` and `packages.*.*`
  '';

  inputs = {
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.platforms.all;
      imports = [
        wrappers.flakeModules.wrappers
      ];
      perSystem =
        { pkgs, ... }:
        {
          wrappers.control_type = "build";
          wrappers.packages = {
            neovim = true;
          };
        };
      flake.wrappers.neovim = ./modules/neovim.nix;
      flake.wrappers.tmux =
        { wlib, pkgs, ... }:
        {
          imports = [ wlib.wrapperModules.tmux ];
          plugins = with pkgs.tmuxPlugins; [ onedark-theme ];
        };
    };
}
