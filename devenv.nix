{
  pkgs,
  ...
}:
{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    nixfmt
  ];

  languages.nix = {
    enable = true;
    lsp.enable = true;
    lsp.package = pkgs.nixd;
  };

  # https://devenv.sh/git-hooks/
  git-hooks.hooks.nixfmt.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
