{ config, lib, pkgs, inputs, systemSettings, ... }:

let
  moduleName = "neovim";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;
  config = lib.mkIf config.modules.${moduleName}.enable  {
    stylix.targets.neovim.enable = false;

    programs.neovim = {
      enable = true;
      package = inputs.neovim-penultimum.packages.${systemSettings.system}.neovim;
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
