{ pkgs, config, ... }:
{
  plugins = {
    tmux-navigator.enable = true;
    nvim-autopairs.enable = true;
    comment.enable = true;
    ts-autotag.enable = true;
    gitsigns.enable = true;

    telescope = {
      enable = true;
      keymaps = {
        "<leader>fa" = "";
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
      };
      settings.defaults = {
        preview.treesitter = true;
      };
    };

    lualine = {
      enable = true;
      settings.options = {
        globalstatus = true;
        component_separators = "│";
        section_separators = "";
      };
    };

    treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        nix
        lua
        bash
        gitignore
        python
        markdown
        markdown_inline
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
        ident.enable = false;
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
        pyright.enable = true;
        gopls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
      };
      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>j" = "goto_next";
          "<leader>k" = "goto_prev";
        };
        lspBuf = {
          K = "hover";
          gd = "definition";
          gD = "declaration";
          gt = "type_definition";
          gr = "references";
          gi = "implementation";
          rn = "rename";
          ca = "code_action";
        };
        extra = map (keymap: keymap // { options.silent = true; }) [
          {
            action = "<cmd>Telescope lsp_references<CR>";
            key = "gR";
          }
          {
            action = "<cmd>Lspsaga show_line_diagnostics<CR><cmd>set wrap<CR>";
            key = "<leader>xd";
          }
        ];
      };
    };
    lspsaga = {
      enable = true;
      lightbulb.enable = false;
      symbolInWinbar.enable = false;
    };

    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        snippet = {
          expand = ''function(args) require("luasnip").lsp_expand(args.body) end'';
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "path"; }
        ];
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
          "<C-q>" = "cmp.mapping.abort()";
        };
      };
    };
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    luasnip.enable = true;

    noice.enable = true;
    notify = {
      enable = true;
      topDown = false;
      render = "compact";
    };

    indent-blankline = {
      enable = true;
      settings.scope.enabled = false;

      # Make the indent characters dimmer (second darkest stylix color)
      settings.indent.highlight = [ "MyIndentBlanklineChar" ];
      luaConfig.pre = ''
        vim.cmd("highlight MyIndentBlanklineChar guifg=${config.lib.stylix.colors.withHashtag.base01} gui=nocombine")
      '';
    };
    guess-indent = {
      enable = true;
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
    web-devicons.enable = true; # for neo-tree
  };

  extraPlugins = let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
  in with pkgs.vimPlugins; [
    vim-obsession

    {
      plugin = nvim-highlight-colors;
      config = toLua /*lua*/ ''
        require("nvim-highlight-colors").setup({
          render = "virtual",
          virtual_symbol = "●",
          virtual_symbol_prefix = " ",
          virtual_symbol_suffix = "",
          virtual_symbol_position = "eol",
        })
      '';
    }
  ];

  extraConfigLua = /*lua*/ ''
    -- fix neo-tree border color
    vim.cmd("highlight! link NeoTreeFloatTitle NeoTreeNormal")
    vim.cmd("highlight! link NeoTreeFloatBorder NeoTreeNormal")
  '';
}
