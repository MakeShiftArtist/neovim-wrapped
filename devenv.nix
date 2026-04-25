{
  pkgs,
  ...
}:
{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    nixfmt
    stylua
  ];

  languages.nix = {
    enable = true;
    lsp.enable = true;
    lsp.package = pkgs.nixd;
  };

  languages.lua = {
    enable = true;
    lsp.enable = true;
  };

  # https://devenv.sh/git-hooks/
  # Format nix code
  git-hooks.hooks.nixfmt.enable = true;
  # Format lua code
  git-hooks.hooks.stylua = {
    enable = true;
    entry = "stylua --config-path stylua.toml";
  };

  # See full reference at https://devenv.sh/reference/options/
}
