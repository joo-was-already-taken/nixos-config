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

        {
          plugin = (nvim-treesitter.withPlugins (plugins: with plugins; [
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
          ]));
          config = lua /*lua*/ ''
            require("nvim-treesitter").setup({
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = true,
              },
            })
          '';
        }
      ];
    };
  };
}
