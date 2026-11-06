{
  description = ''
    MakeShiftArtist's custom neovim configuation
    Uses nix flakes, flake-parts, and wrapper-modules
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.inputs.flake-parts.follows = "flake-parts";
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
      flake.wrappers.neovim =
        { pkgs, ... }:
        {
          imports = [ ./modules/neovim.nix ];
          config.package = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };

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
