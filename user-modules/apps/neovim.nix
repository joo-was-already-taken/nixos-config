{ config, lib, pkgs, ... }:

let
  moduleName = "neovim";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;
  config = lib.mkIf config.modules.${moduleName}.enable  {
    stylix.targets.neovim.enable = false;

    programs.neovim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = [ pkgs.wl-clipboard ];
    };
    neovim-penultimum.enable = true;

    home.packages = with pkgs; [
      bash-language-server
      nil
      tinymist
    ];
  };
}
