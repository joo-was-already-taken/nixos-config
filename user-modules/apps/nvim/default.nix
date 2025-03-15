{ config, lib, pkgs, ... }:
let
  moduleName = "nvim";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  imports = [
    ./notes.nix
  ];

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.file.".config/nvim/lua" = {
      source = ./lua;
      recursive = true;
    };

    stylix.targets.neovim.enable = false;

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
        nvim-ts-autotag
        vim-obsession

        {
          plugin = gitsigns-nvim;
          config = lua /*lua*/ ''
            require("gitsigns").setup({})
          '';
        }
        {
          plugin = comment-nvim;
          config = lua /*lua*/ ''
            require("Comment").setup({})
          '';
        }

        {
          plugin = catppuccin-nvim;
          config = lua /*lua*/ ''
            require("catppuccin").setup({
              flavour = "macchiato",
              transparent_background = false,
              show_end_of_buffer = true,
              term_colors = true,
              background = {
                dark = "macchiato",
                light = "latte",
              },
              default_integrations = true,
              integrations = {
                cmp = true,
                gitsigns = true,
                neotree = true,
                treesitter = true,
                telescope = { enabled = true },
                native_lsp = { enabled = true },
              },
              highlight_overrides = {
                macchiato = function(macchiato)
                  return {
                    LineNr = { fg = macchiato.lavender },
                    CursorLineNr = { fg = macchiato.sky },
                  }
                end
              },
            })
            vim.cmd.colorscheme("catppuccin")
            -- local macchiato = require("catppuccin.palettes").get_palette "macchiato"
            -- for k, v in pairs(macchiato) do
            --   print(k .. ", " .. v)
            -- end
          '';
        }

        {
          plugin = nvim-autopairs;
          config = lua ''require("nvim-autopairs").setup({})'';
        }

        # plugins/telescope.lua
        telescope-nvim
        # plugins/lualine.lua
        lualine-nvim
        # plugins/harpoon.lua
        harpoon2

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
          config = lua /*lua*/ ''
            require("noice").setup({})
          '';
        }
        # plugins/notify.lua
        nvim-notify

        {
          plugin = indent-blankline-nvim;
          config = lua /*lua*/ ''
            require("ibl").setup({
              scope = { enabled = false },
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

        {
          plugin = (nvim-treesitter.withPlugins (plugins: with plugins; [
            tree-sitter-nix
            tree-sitter-lua
            tree-sitter-bash
            tree-sitter-gitignore
            tree-sitter-python
            tree-sitter-markdown
            tree-sitter-markdown_inline
            tree-sitter-latex
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
          ]));
          config = lua /*lua*/ ''
            require("nvim-treesitter.configs").setup({
              auto_install = false,
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
              indent = { enable = true },
              context_commentstring = {
                enable = true,
                enable_autocmd = false,
              },
            })
          '';
        }

        # plugins/markdown.lua
        render-markdown-nvim
        obsidian-nvim
        markdown-preview-nvim
        no-neck-pain-nvim
      ];
    };
  };
}
