{
  config,
  pkgs,
  lib,
  wlib,
  ...
}:
let
  # Formatter packages for conform: only added to PATH when the autoformat
  # (conform) spec is enabled. Tools that are also a language server or used
  # by one (deno, ruff, nixfmt) are listed unconditionally instead.
  formatters = lib.optionals config.specs.autoformat.enable;
in
{
  imports = [ wlib.wrapperModules.neovim ];

  # This enables you to add runtimePkgs per spec, rather than just globally
  # This is useful if certain plugins require packages, but you want those
  # plugins (and requirements) to be optional
  config.specMods = {
    options.runtimePkgs = lib.mkOption {
      type = lib.types.listOf wlib.types.stringable;
      default = [ ];
      description = "a runtimePkgs spec field to put packages to suffix to the PATH";
    };
  };
  # Several specs can need the same package (e.g. ruff is both a language server
  # and a formatter), so de-duplicate the collected PATH entries.
  config.runtimePkgs = lib.unique (config.specCollect (acc: v: acc ++ (v.runtimePkgs or [ ])) [ ]);

  # Every Lua file in ./nvim is loaded by exactly one spec below. There is no
  # ./nvim/init.lua on purpose, so the wrapper doesn't run anything implicitly.
  config.settings.config_directory = ./nvim;
  # Enable it as it's own binary, to avoid conflicts
  # config.binName = "nvix";

  # You can declare your own options!
  options.settings.colorscheme = lib.mkOption {
    type = lib.types.enum [ "tokyonight" ];
    default = "tokyonight";
  };

  config.specs.colorscheme = {
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
    runtimePkgs = with pkgs; [
      nixd
      nixfmt
    ];
    config = builtins.readFile ./nvim/languages/nix.lua;
  };

  config.specs.rust = {
    data = null;
    runtimePkgs =
      with pkgs;
      [
        rust-analyzer
        clippy
      ]
      ++ formatters [ rustfmt ];
    config = builtins.readFile ./nvim/languages/rust.lua;
  };

  config.specs.deno = {
    data = null;
    runtimePkgs = with pkgs; [
      # language server and conform formatter (deno_fmt)
      deno
    ];
    config = builtins.readFile ./nvim/languages/deno.lua;
  };

  config.specs.lua = {
    data = null;
    runtimePkgs =
      with pkgs;
      [
        lua-language-server
      ]
      ++ formatters [ stylua ];
    config = builtins.readFile ./nvim/languages/lua.lua;
  };

  config.specs.options = {
    data = null;
    runtimePkgs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      # Clipboard provider for clipboard=unnamedplus on Wayland (macOS uses the built-in pbcopy/pbpaste)
      pkgs.wl-clipboard
    ];
    config = builtins.readFile ./nvim/options.lua;
  };

  config.specs.treesitter = {
    data = with pkgs.vimPlugins; [
      # Parsers come from nix, so nothing is compiled or downloaded at runtime
      (nvim-treesitter.withPlugins (
        p: with p; [
          bash
          css
          html
          javascript
          json
          lua
          markdown
          markdown_inline
          nix
          python
          query
          regex
          rust
          toml
          tsx
          typescript
          vim
          vimdoc
          yaml
        ]
      ))
    ];
    runtimePkgs = with pkgs; [
      # Required by nvim-treesitter (checkhealth, :TSInstall/:TSUpdate)
      tree-sitter
    ];
    config = builtins.readFile ./nvim/plugins/treesitter.lua;
  };

  config.specs.keymaps = {
    data = null;
    # Sets <leader>; specs that map <leader> must declare `after = [ "keymaps" ]`
    config = builtins.readFile ./nvim/keymaps.lua;
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
    # Formatters are provided by each language spec, not here. The fallbacks in
    # conform-nvim.lua (black, prettier, treefmt) are expected to come from the project.
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
    runtimePkgs = with pkgs; [
      git # git_files
      fd # find_files
      ripgrep # grep_string
    ];
    after = [ "keymaps" ];
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
    runtimePkgs =
      with pkgs;
      [
        typescript-language-server
      ]
      ++ formatters [ prettierd ];
    config = builtins.readFile ./nvim/languages/typescript.lua;
  };

  config.specs.python = {
    data = null;
    runtimePkgs = with pkgs; [
      # language server and conform formatter
      ruff
      ty
    ];
    config = builtins.readFile ./nvim/languages/python.lua;
  };

  config.specs.yaml = {
    data = null;
    runtimePkgs =
      with pkgs;
      [
        yaml-language-server
      ]
      ++ formatters [ prettierd ];
    config = builtins.readFile ./nvim/languages/yaml.lua;
  };

  config.specs.json = {
    data = null;
    runtimePkgs =
      with pkgs;
      [
        vscode-langservers-extracted
      ]
      ++ formatters [ prettierd ];
    config = builtins.readFile ./nvim/languages/json.lua;
  };

  config.specs.schemastore = {
    data = with pkgs.vimPlugins; [
      # JSON/YAML schemas for jsonls and yamlls. See https://github.com/b0o/SchemaStore.nvim
      SchemaStore-nvim
    ];

    # Must run after the base jsonls/yamlls configs so these overrides win the merge.
    after = [
      "json"
      "yaml"
    ];

    config = builtins.readFile ./nvim/plugins/schemastore.lua;
  };

  config.specs.bash = {
    data = null;
    runtimePkgs = with pkgs; [
      bash-language-server
      # bash-language-server uses shellcheck for diagnostics when it is on PATH
      shellcheck
    ];
    config = builtins.readFile ./nvim/languages/bash.lua;
  };

  config.specs.completion = {
    data = with pkgs.vimPlugins; [
      blink-cmp
    ];
    config = builtins.readFile ./nvim/plugins/blink-cmp.lua;
  };
}
