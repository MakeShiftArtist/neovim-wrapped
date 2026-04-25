{
  config,
  pkgs,
  lib,
  wlib,
  ...
}:
{
  imports = [ wlib.wrapperModules.neovim ];

  # This enables you to add extraPackages per spec, rather than just globally
  # This is useful if certain plugins require packages, but you want those
  # plugins (and requirements) to be optional
  config.specMods = {
    options.extraPackages = lib.mkOption {
      type = lib.types.listOf wlib.types.stringable;
      default = [ ];
      description = "a extraPackages spec field to put packages to suffix to the PATH";
    };
  };
  config.extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [ ])) [ ];

  config.settings.config_directory = ./nvim;
  config.binName = "nvix";

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
    config = builtins.readFile ./nvim/plugins/${config.settings.colorscheme}.lua;
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

  config.specs.deno = {
    data = null;
    extraPackages = with pkgs; [
      deno
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
    data = null;
    extraPackages = with pkgs; [
      wl-clipboard
      tree-sitter
      fd
      ripgrep
    ];
    config = builtins.readFile ./nvim/init.lua;
  };

  config.specs.keymaps = {
    data = null;
    config = builtins.readFile ./nvim/keymaps.lua;
  };

  config.specs.lsp = {
    data = null;
    config = builtins.readFile ./nvim/lsp.lua;
  };

  config.specs.surround = {
    data = with pkgs.vimPlugins; [
      # Adds surround vim motions
      nvim-surround
    ];

    config = builtins.readFile ./nvim/plugins/nvim-surround.lua;

  };

  config.specs.autopairs = {

    data = with pkgs.vimPlugins; [
      nvim-autopairs
    ];

    config = builtins.readFile ./nvim/plugins/nvim-autopairs.lua;
  };

  config.specs.autoformat = {
    data = with pkgs.vimPlugins; [
      conform-nvim
    ];

    config = builtins.readFile ./nvim/plugins/conform-nvim.lua;
  };

  config.specs.statusline = {
    data = with pkgs.vimPlugins; [
      lualine-nvim
    ];

    config = builtins.readFile ./nvim/plugins/lualine-nvim.lua;
  };

  config.specs.telescope = {
    data = with pkgs.vimPlugins; [
      # `c` port of fzf. See https://github.com/nvim-telescope/telescope-fzf-native.nvim
      telescope-fzf-native-nvim
      telescope-nvim
      # Required dependency for Telescope.nvim
      plenary-nvim
    ];

    config = builtins.readFile ./nvim/plugins/telescope.lua;
  };

  config.specs.luasnip = {
    data = with pkgs.vimPlugins; [
      luasnip
    ];

    config = builtins.readFile ./nvim/plugins/luasnip.lua;
  };

  config.specs.typescript = {
    data = null;
    extraPackages = with pkgs; [
      nodejs
      typescript-language-server
      # nodePackages.vscode-langservers-extracted
    ];
  };

  config.specs.python = {
    data = null;
    extraPackages = with pkgs; [
      ruff
      ty
    ];
  };

  config.specs.bash = {
    data = null;
    extraPackages = with pkgs; [
      bash-language-server
    ];
  };

  config.specs.completion = {
    data = with pkgs.vimPlugins; [
      blink-cmp
    ];
    config = builtins.readFile ./nvim/plugins/blink-cmp.lua;
  };
}
