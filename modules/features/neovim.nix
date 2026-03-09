{
  flake.modules.nixos.neovim = {
    nix.settings = {
      substituters = [ "https://joo-was-already-taken.cachix.org" ];
      trusted-substituters = [ "https://joo-was-already-taken.cachix.org" ];
      trusted-public-keys = [
        "joo-was-already-taken.cachix.org-1:AYY8fXIpeK+jciPUMGWmUpp9zwP7zoruz0/mJ/N1BoQ="
      ];
    };
  };

  flake.modules.homeManager.neovim = { inputs, pkgs, ... }: {
    imports = [
      inputs.neovim-penultimum.homeManagerModules.default
    ];

    programs.neovim = {
      enable = true;
      package = inputs.neovim-penultimum.packages.${pkgs.system}.neovim;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    programs.neovim-penultimum.enable = true;

    home.packages = with pkgs; [
      bash-language-server
      nil
      tinymist
    ];
  };
}
