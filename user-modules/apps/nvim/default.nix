{ config, lib, myLib, pkgs, ... }:
let
  moduleName = "nvim";
  nvimPkgs = pkgs.unstable;
  colorscheme = myLib.styling.importNvimColorscheme nvimPkgs;
  lushThemes = let
    themesDir = ../../../styling/nvim;
    dir = builtins.readDir themesDir;
    fileNames = builtins.attrNames (lib.filterAttrs (_: type: type == "regular") dir);
  in map (fileName: rec {
      inherit fileName;
      name = builtins.replaceStrings [ ".lua" ] [ "" ] fileName;
      path = "${themesDir}/${fileName}";
      content = builtins.readFile path;
    }) fileNames;

  # shipwright-nvim = pkgs.vimUtils.buildVimPlugin {
  #   pname = "shipwright-nvim";
  #   version = "";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "rktjmp";
  #     repo = "shipwright.nvim";
  #     rev = "e596ab4";
  #     sha256 = "sha256-xh/2m//Cno5gPucjOYih79wVZj3X1Di/U3/IQhKXjc0=";
  #   };
  # };

in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  imports = [
    ./notes.nix
  ];

  config = lib.mkIf config.modules.${moduleName}.enable {
    stylix.targets.neovim.enable = false;

    home.file = {
      ".config/nvim/lua" = {
          source = ./lua;
          recursive = true;
        };
      ".config/nvim/lua/colorschemes/colorscheme.lua".text = colorscheme.config;
    }
      // builtins.listToAttrs (map (theme: {
        name = ".config/nvim/lua/lush_themes/${theme.fileName}";
        value.text = theme.content;
      }) lushThemes)
      // builtins.listToAttrs (map (theme: {
        name = ".config/nvim/colors/${theme.fileName}";
        value.text = /*lua*/ ''
          local theme = require("lush_themes.${theme.name}")
          require("lush")(theme)
          return theme
        '';
      }) lushThemes);

    programs.neovim = {
      enable = true;
      package = nvimPkgs.neovim-unwrapped;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        wl-clipboard
        ripgrep

        nil
        tinymist
      ];

      extraLuaConfig = let
        packpathDirs = pkgs.vimUtils.packDir
          config.programs.neovim.finalPackage.passthru.packpathDirs;
      in /*lua*/ ''
        require("config")

        require("lazy").setup({
          defaults = {
              version = false,
              lazy = false,
            },

          performance = {
            reset_packpath = false,
            rtp = { reset = false },
          },
          dev = {
            path = "${packpathDirs}/pack/myNeovimPackages/start",
            patterns = { "" },
          },
          install = { missing = false },

          spec = {
            { import = "plugins" },
            { import = "colorschemes" },
          },
        })
      '';

      plugins = with nvimPkgs.vimPlugins; [
        lush-nvim
        # shipwright-nvim

        lazy-nvim

        plenary-nvim

        tmux-navigator
        vim-obsession
        nvim-surround
        nvim-ts-autotag
        typst-preview-nvim
        gitsigns-nvim
        git-conflict-nvim
        comment-nvim
        nvim-autopairs

        # AI
        windsurf-nvim

        smart-splits-nvim

        # plugins/telescope.lua
        telescope-nvim
        # plugins/lualine.lua
        lualine-nvim
        # plugins/harpoon.lua
        harpoon2
        # plugins/conform.lua
        conform-nvim

        # plugins/lsp.lua
        nvim-lspconfig
        # dependencies:
        lspsaga-nvim

        # plugins/cmp.lua
        nvim-cmp
        # dependencies:
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp_luasnip
        luasnip
        friendly-snippets

        noice-nvim
        # plugins/notify.lua
        nvim-notify

        indent-blankline-nvim
        undotree

        # plugins/neotree.lua
        neo-tree-nvim
        # dependencies:
        nvim-web-devicons

        nvim-highlight-colors

        (nvim-treesitter.withPlugins (plugins: with plugins; [
          tree-sitter-nix
          tree-sitter-lua
          tree-sitter-bash
          tree-sitter-gitignore
          tree-sitter-python
          tree-sitter-markdown
          tree-sitter-markdown_inline
          tree-sitter-norg
          tree-sitter-norg-meta
          tree-sitter-typst
          tree-sitter-latex
          tree-sitter-typst
          tree-sitter-make
          tree-sitter-regex
          tree-sitter-toml
          tree-sitter-yaml
          tree-sitter-json
          tree-sitter-vim
          tree-sitter-vimdoc
          tree-sitter-rust
          tree-sitter-haskell
          tree-sitter-elisp
          tree-sitter-go
          tree-sitter-html
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-cmake
          tree-sitter-zig
          tree-sitter-javascript
          tree-sitter-css
        ]))

        # plugins/url.lua
        url-open

        # plugins/markdown.lua
        render-markdown-nvim
        markdown-preview-nvim
        no-neck-pain-nvim
      ] ++ colorscheme.plugins;
    };
  };
}
