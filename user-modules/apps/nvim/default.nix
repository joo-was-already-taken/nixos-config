{ config, lib, pkgs, ... }:
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
        smartindent = true;
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

      keymaps = [
        {
          action = "<cmd>Neotree filesystem toggle reveal float<CR>";
          key = "<leader>e";
        }
        {
          action = "<cmd>Neotree git_status toggle reveal float<CR>";
          key = "<leader>g";
        }
      ];

      plugins = {
        lualine.enable = true;

        treesitter = {
          enable = true;
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            nix
            lua
            bash
            gitignore
            python
            markdown
            make
            regex
            toml
            yaml
            json
            vim
            vimdoc
            rust
            haskell
            go
            html
            c
            cpp
            cmake
          ];
          settings = {
            highlight = {
              enable = true;
              additional_vim_regex_highlighting = true;
            };
          };
        };

        lsp = {
          enable = true;
          servers = {
            nil_ls.enable = true;
            lua_ls.enable = true;
            rust_analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
          };
        };

        tmux-navigator.enable = true;
        nvim-autopairs.enable = true;
        comment.enable = true;

        indent-blankline = {
          enable = true;
          settings.scope.enabled = false;
          
          # Make the indent characters dimmer (second darkest stylix color)
          settings.indent.highlight = [ "MyIndentBlanklineChar" ];
          luaConfig.pre = ''
            vim.cmd("highlight MyIndentBlanklineChar guifg=${config.lib.stylix.colors.withHashtag.base01} gui=nocombine")
          '';
        };

        neo-tree = {
          enable = true;
          extraOptions = {
            popup_border_style = "rounded";
            enable_git_status = true;
            enable_diagnostics = true;
            default_component_configs = {
              file_size = {
                enabled = true;
                required_width = 54;
              };
              type = {
                enabled = true;
                required_width = 54;
              };
              last_modified = {
                enabled = true;
                required_width = 78;
              };
              created = {
                enabled = true;
                required_width = 100;
              };
              symlink_target = {
                enabled = false;
              };
            };
            window = {
              position = "current";
            };
          };
        };
        web-devicons.enable = true;
      };
    };
  };
}
