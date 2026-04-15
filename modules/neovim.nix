{
  config,
  pkgs,
  lib,
  wlib,
  ...
}:
{
  imports = [ wlib.wrapperModules.neovim ];
  # You can declare your own options!
  options.settings.colorscheme = lib.mkOption {
    type = lib.types.enum [ "tokyonight" ];
    default = "tokyonight";
  };

  config.specs.colorscheme = {
    lazy = true;
    data = builtins.getAttr config.settings.colorscheme (
      with pkgs.vimPlugins;
      {
        "tokyonight" = tokyonight-nvim;
      }
    );
    config = builtins.readFile ./nvim/plugins/tokyonight.lua;
  };

  config.specs.nix = {
    data = null;
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
  };

  config.specs.rust = {
    data = null;
    extraPackages = with pkgs; [
      rust-analyzer
      clippy
    ];
  };

  config.specs.lua = {
    data = null;
    extraPackages = with pkgs; [
      lua-language-server
      stylua
    ];
  };

  config.specs.general = {
    extraPackages = with pkgs; [
      wl-clipboard
      tree-sitter
      fd
      ripgrep
    ];

    data = with pkgs.vimPlugins; [
      # `c` port of fzf. See https://github.com/nvim-telescope/telescope-fzf-native.nvim
      telescope-fzf-native-nvim
      # Required dependency for Telescope.nvim
      plenary-nvim
      # Adds surround vim motions
      nvim-surround
    ];
  };

  config.specs.typescript = {
    data = null;
    extraPackages = with pkgs; [
      nodejs
      typescript-language-server
      # nodePackages.vscode-langservers-extracted
    ];
  };

  config.specs.bash = {
    lazy = false;
    extraPackages = with pkgs; [
      bash-language-server
    ];
  };
}
