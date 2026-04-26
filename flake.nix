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

      flake.homeModules.neovim-wrapped =
        { pkgs, ... }:
        {
          programs.neovim = {
            enable = true;
            package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.default;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            # Disabled by default, but needed to silence warnings since home.stateVersion is older
            withPython3 = false;
            withRuby = false;
          };
        };

      flake.nixosModules.neovim-wrapped =
        { pkgs, ... }:
        {
          programs.neovim = {
            enable = true;
            package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.default;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            # Disabled by default, but needed to silence warnings since home.stateVersion is older
            withPython3 = false;
            withRuby = false;
          };
        };

      flake.nixosModules.default = inputs.self.nixosModules.neovim-wrapped;
      flake.homeModules.default = inputs.self.homeModules.neovim-wrapped;
    };
}
