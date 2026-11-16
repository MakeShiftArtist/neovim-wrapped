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
      wrappers,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      imports = [
        wrappers.flakeModules.wrappers
      ];
      perSystem =
        { config, pkgs, ... }:
        {
          packages.default = config.packages.neovim;
          wrappers.control_type = "build";
          wrappers.packages = {
            neovim = true;
          };

          devShells.default = pkgs.mkShell {
            packages = [ config.packages.default ];

            shellHook = ''
              echo "Neovim wrapped (nvix) development environment loaded";
            '';
          };
        };
      flake.wrappers.neovim = ./modules/neovim.nix;

      flake.homeModules.neovim-wrapped = import ./modules/program.nix {
        inherit (inputs) self;
        isHomeManager = true;
      };

      flake.nixosModules.neovim-wrapped = import ./modules/program.nix {
        inherit (inputs) self;
        isHomeManager = false;
      };

      flake.nixosModules.default = inputs.self.nixosModules.neovim-wrapped;
      flake.homeModules.default = inputs.self.homeModules.neovim-wrapped;
    };
}
