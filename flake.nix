{
  description = ''
    MakeShiftArtist's custom neovim configuation
    Uses nix flakes, flake-parts, and wrapper-modules
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };
  outputs =
    {
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
        { ... }:
        {
          wrappers.control_type = "build";
          wrappers.packages = {
            neovim = true;
          };
        };
      flake.wrappers.neovim = ./modules/neovim.nix;

      flake.homeModules.neovim =
        { config, lib, ... }:
        {
          imports = [
            (inputs.wrappers.lib.mkInstallModule {
              loc = [
                "home"
                "packages"
              ];
              name = "neovim";
              value = inputs.wrappers.lib.wrapperModules.neovim;
            })
          ];
        };
    };
}
