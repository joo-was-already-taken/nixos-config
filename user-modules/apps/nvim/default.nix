{ config, lib, pkgs, ... }:
let
  moduleName = "nvim";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;
  
  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      
      colorschemes.gruvbox.enable = true;

      plugins = {
        lualine.enable = true;

        lsp = {
          enable = true;
          servers = {
            nil_ls.enable = true;
            # lua_ls.enable = true;
            # rust_analyzer = {
            #   enable = true;
            #   installCargo = true;
            #   installRustc = true;
            # };
          };
        };
      };
    };
  };
}
