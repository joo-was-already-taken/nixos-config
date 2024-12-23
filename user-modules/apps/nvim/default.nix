{ config, lib, pkgs, ... }@args:
let
  moduleName = "nvim";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = with pkgs; [
      ripgrep
    ];

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
        showtabline = 0; # never
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

      autoCmd = [
        {
          # Fix noice search popup border color
          callback.__raw = ''
            function()
              local get_hl = function(hl) return vim.api.nvim_get_hl_by_name(hl, true) end
              local fg = get_hl("NoiceCmdlinePopupBorderSearch").foreground
              local bg = get_hl("NoiceCmdlinePopup").background
              vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = fg, bg = bg })
            end
          '';
          event = [ "VimEnter" ];
        }
      ];

      keymaps = import ./keymaps.nix;
      plugins = (import ./plugins.nix args).plugins;
      extraPlugins = (import ./plugins.nix args).extraPlugins;

      extraConfigLua = (import ./plugins.nix args).extraConfigLua;
    };
  };
}
