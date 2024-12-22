{ config, lib, pkgs, ... }@args:
let
  moduleName = "nvim";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      enableMan = true;
      
      colorschemes.gruvbox.enable = true;

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      globals = {
        mapleader = " ";
        maplocal = " ";
      };

      opts = {
        # Indentation
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
        smarttab = true;
        smartindent = true;
        autoindent = true;
        wrap = false;
        # Search
        incsearch = true;
        ignorecase = true;
        smartcase = true;
        hlsearch = true;
        # Appearance
        number = true;
        relativenumber = true;
        termguicolors = true;
        signcolumn = "yes";
        cmdheight = 1;
        scrolloff = 10;
        completeopt = "menuone,noinsert,noselect";
        # Behaviour
        hidden = true;
        errorbells = false;
        swapfile = false;
        backup = false;
        backspace = "indent,eol,start";
        splitright = true;
        splitbelow = true;
        autochdir = false;
        mouse = "a";
        modifiable = true;
        encoding = "UTF-8";
      };

      keymaps = import ./keymaps.nix;
      plugins = (import ./plugins.nix args).plugins;
      extraPlugins = (import ./plugins.nix args).extraPlugins;
    };
  };
}
