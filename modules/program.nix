# The `programs.neovim-wrapped` module, shared by the NixOS and Home Manager modules.
#
# With the default binName ("nvim") it only swaps the package used by `programs.neovim`;
# everything else is opt-in. Under another name (e.g. "nvix") it installs the package on
# its own, so another Neovim can still be installed through `programs.neovim`.
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

  # Installed through programs.neovim, which can handle the editor and aliases itself
  viaProgramsNeovim = cfg.binName == "nvim";

  exe = "${cfg.package}/bin/${cfg.binName}";

  # The wrapped package also links the plain Neovim's bin/nvim and share/ (man pages,
  # desktop file, icons), which would collide with another Neovim. Under another name,
  # install only the renamed executables (nvix, nvix-node, ...).
  standalonePackage = pkgs.runCommand cfg.binName { meta.mainProgram = cfg.binName; } ''
    mkdir -p $out/bin
    ln -s ${cfg.package}/bin/${cfg.binName}* $out/bin/
  '';

  # Aliases that programs.neovim doesn't provide here: all of them under another name,
  # and vimdiff on NixOS (its programs.neovim has no vimdiffAlias option).
  linkAliases =
    lib.optional (cfg.viAlias && !viaProgramsNeovim) "vi"
    ++ lib.optional (cfg.vimAlias && !viaProgramsNeovim) "vim";
  vimdiffScript = cfg.vimdiffAlias && !(viaProgramsNeovim && isHomeManager);
  aliasesPackage = pkgs.runCommand "${cfg.binName}-aliases" { } ''
    mkdir -p $out/bin
    ${lib.concatMapStrings (alias: "ln -s ${exe} $out/bin/${alias}\n") linkAliases}
    ${lib.optionalString vimdiffScript ''
      printf '#!%s\nexec %s -d "$@"\n' ${pkgs.runtimeShell} ${exe} > $out/bin/vimdiff
      chmod +x $out/bin/vimdiff
    ''}
  '';

  packages =
    lib.optional (!viaProgramsNeovim) standalonePackage
    ++ lib.optional (linkAliases != [ ] || vimdiffScript) aliasesPackage;
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

    binName = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      example = "nvix";
      description = ''
        Name of the executable. With the default `nvim`, it's installed as the
        `programs.neovim` package. With any other name, such as `nvix`, it's installed
        on its own, so another Neovim can be installed alongside it (including through
        `programs.neovim`).
      '';
    };

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to set it as the default editor, using the `EDITOR` environment variable.";
    };

    viAlias = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether `vi` should run it.";
    };

    vimAlias = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether `vim` should run it.";
    };

    vimdiffAlias = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether `vimdiff` should run it in diff mode (`-d`).";
    };

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default.wrap {
        inherit (cfg) settings binName;
      };
      defaultText = lib.literalMD "the flake's package, built with `programs.neovim-wrapped.settings` and `binName`";
      description = "The resulting Neovim package.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # Named nvim: only swap the programs.neovim package. The rest are defaults, so
      # programs.neovim's own options can still be set directly.
      (lib.mkIf viaProgramsNeovim {
        programs.neovim = {
          enable = true;
          inherit (cfg) package;
          defaultEditor = lib.mkDefault cfg.defaultEditor;
          viAlias = lib.mkDefault cfg.viAlias;
          vimAlias = lib.mkDefault cfg.vimAlias;
          # The wrapped package has its own providers, so don't add programs.neovim's.
          # Also silences warnings when home.stateVersion is older.
          withPython3 = lib.mkDefault false;
          withRuby = lib.mkDefault false;
        }
        // lib.optionalAttrs isHomeManager {
          vimdiffAlias = lib.mkDefault cfg.vimdiffAlias;
        };
      })

      # Under another name, set EDITOR here instead (same priority as programs.neovim)
      (lib.mkIf (!viaProgramsNeovim && cfg.defaultEditor) (
        if isHomeManager then
          { home.sessionVariables.EDITOR = cfg.binName; }
        else
          { environment.variables.EDITOR = lib.mkOverride 900 cfg.binName; }
      ))

      (lib.mkIf (packages != [ ]) (
        if isHomeManager then { home.packages = packages; } else { environment.systemPackages = packages; }
      ))
    ]
  );
}
