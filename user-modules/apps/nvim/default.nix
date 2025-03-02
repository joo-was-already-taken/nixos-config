{ config, lib, pkgs, ... }:
let
  moduleName = "nvim";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.file.".config/nvim/lua" = {
      source = ./lua;
      recursive = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        wl-clipboard
        ripgrep

        nil
        lua-language-server
      ];

      extraLuaConfig = /*lua*/ ''
        require("config")
      '';

      plugins = let
        lua = str: "lua << EOF\n${str}\nEOF\n";
      in with pkgs.vimPlugins; [
        tmux-navigator
        nvim-autopairs
        comment-nvim
        nvim-ts-autotag
        gitsigns-nvim
        vim-obsession

        # plugins/telescope.lua
        telescope-nvim
        # plugins/lualine.lua
        lualine-nvim

        # plugins/lsp.lua
        nvim-lspconfig
        # dependencies:
        {
          plugin = lspsaga-nvim;
          config = lua /*lua*/ ''
            require("lspsaga").setup({
              ui = { code_action = "" },
              symbol_in_winbar = { enable = false },
            })
          '';
        }

        # plugins/cmp.lua
        nvim-cmp
        # dependencies:
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        luasnip

        {
          plugin = noice-nvim;
          config = lua ''require("noice").setup({})'';
        }
        # plugins/notify.lua
        nvim-notify

        {
          plugin = indent-blankline-nvim;
          config = lua ''
            vim.api.nvim_set_hl(0, "MyIblIndent", { fg = "${config.lib.stylix.colors.withHashtag.base01}" })
            require("ibl").setup({
              scope = { enabled = false },
              indent = { highlight = { "MyIblIndent" } },
            })
          '';
        }

        # plugins/neotree.lua
        neo-tree-nvim
        # dependencies:
        nvim-web-devicons

        {
          plugin = nvim-highlight-colors;
          config = lua /*lua*/ ''
            require("nvim-highlight-colors").setup({
              render = "virtual",
              virtual_symbol = "●",
              virtual_symbol_prefix = " ",
              virtual_symbol_suffix = "",
              virtual_symbol_position = "eol",
            })
          '';
        }

        (nvim-treesitter.withPlugins (plugins: with plugins; [
          tree-sitter-nix
          tree-sitter-lua
          tree-sitter-bash
          tree-sitter-gitignore
          tree-sitter-python
          tree-sitter-markdown
          tree-sitter-markdown_inline
          tree-sitter-make
          tree-sitter-regex
          tree-sitter-toml
          tree-sitter-yaml
          tree-sitter-json
          tree-sitter-vim
          tree-sitter-vimdoc
          tree-sitter-rust
          tree-sitter-haskell
          tree-sitter-go
          tree-sitter-html
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-cmake
          tree-sitter-zig
          tree-sitter-java
        ]))
      ];
    };

    # home.file.".config/nvim/init.lua".text = /*lua*/ ''
    #   require()
    # '';
    # home.file.".config/nvim/lua" = {
    #   source = ./lua;
    #   recursive = true;
    # };

    # home.file.".config/clangd/config.yaml".text = /*yaml*/ ''
    #   CompileFlags:
    #     Add: [-std=c++23]
    # '';

  #   programs.nixvim = {
  #     enable = true;
  #     defaultEditor = true;
  #
  #     # nixpkgs.useGlobalPackages = true;
  #
  #     enableMan = true;
  #
  #     # colorschemes.gruvbox.enable = true;
  #     colorschemes.base16 = {
  #       enable = true;
  #       colorscheme = styleSettings.withHash.editorColors;
  #     };
  #
  #     clipboard = {
  #       register = "unnamedplus";
  #       providers.wl-copy.enable = true;
  #     };
  #
  #     globals = {
  #       mapleader = " ";
  #       maplocal = " ";
  #     };
  #
  #     opts = {
  #       # Indentation
  #       tabstop = 2;
  #       shiftwidth = 2;
  #       softtabstop = 2;
  #       expandtab = true;
  #       smarttab = true;
  #       smartindent = true;
  #       autoindent = true;
  #       wrap = false;
  #       # Search
  #       incsearch = true;
  #       ignorecase = true;
  #       smartcase = true;
  #       hlsearch = true;
  #       # Appearance
  #       number = true;
  #       relativenumber = true;
  #       termguicolors = true;
  #       signcolumn = "yes";
  #       cmdheight = 1;
  #       scrolloff = 10;
  #       completeopt = "menuone,noinsert,noselect";
  #       showtabline = 0; # never
  #       listchars = "trail:·"; # trailing whitespace
  #       list = true;
  #       # Behaviour
  #       hidden = true;
  #       errorbells = false;
  #       swapfile = false;
  #       backup = false;
  #       backspace = "indent,eol,start";
  #       splitright = true;
  #       splitbelow = true;
  #       autochdir = false;
  #       mouse = "a";
  #       modifiable = true;
  #       encoding = "UTF-8";
  #     };
  #
  #     autoCmd = [
  #       {
  #         # Fix noice search popup border color
  #         callback.__raw = ''
  #           function()
  #             local get_hl = function(hl) return vim.api.nvim_get_hl_by_name(hl, true) end
  #             local fg = get_hl("NoiceCmdlinePopupBorderSearch").foreground
  #             local bg = get_hl("NoiceCmdlinePopup").background
  #             vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = fg, bg = bg })
  #           end
  #         '';
  #         event = [ "VimEnter" ];
  #       }
  #     ];
  #
  #     keymaps = import ./keymaps.nix;
  #     plugins = (import ./plugins.nix args).plugins;
  #     extraPlugins = (import ./plugins.nix args).extraPlugins;
  #
  #     extraConfigLua = (import ./plugins.nix args).extraConfigLua;
  #   };
  };
}
