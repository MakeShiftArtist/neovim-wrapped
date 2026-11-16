# The `programs.neovim-wrapped` module, shared by the NixOS and Home Manager modules.
{
  self,
  isHomeManager,
}:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.neovim-wrapped;
in
{
  options.programs.neovim-wrapped = {
    enable = lib.mkEnableOption "MakeShiftArtist's wrapped Neovim configuration";

    settings.rust = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable Rust language support (rust-analyzer, clippy checks and rustfmt formatting).";
      };
      toolchain.enable = lib.mkEnableOption ''
        a bundled Rust toolchain (cargo, rustc, clippy, rustfmt, std sources and a C
        linker) for Rust development without a project dev shell. It adds about 2 GiB,
        so by default the toolchain is expected to come from the project (dev shell or rustup)'';
    };

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default.wrap {
        inherit (cfg) settings;
      };
      defaultText = lib.literalMD "the flake's package, built with `programs.neovim-wrapped.settings`";
      description = "The resulting Neovim package.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      inherit (cfg) package;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      # Disabled by default, but needed to silence warnings since home.stateVersion is older
      withPython3 = false;
      withRuby = false;
    }
    # NixOS' programs.neovim has no vimdiffAlias option
    // lib.optionalAttrs isHomeManager {
      vimdiffAlias = true;
    };
  };
}
