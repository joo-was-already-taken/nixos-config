{ config, lib, myLib, pkgs, ... }:
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
      package = pkgs.unstable.neovim-unwrapped;
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
          defaults = { version = false },

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
          },
        })
      '';

      plugins = let
        vimPlugins = pkgs.unstable.vimPlugins;
      in with vimPlugins; [
        (myLib.styling.importNvimColorscheme vimPlugins)

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

        # plugins/telescope.lua
        telescope-nvim
        # plugins/lualine.lua
        lualine-nvim
        # plugins/harpoon.lua
        { plugin = harpoon2; config = ""; }
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

        # plugins/neotree.lua
        neo-tree-nvim
        # dependencies:
        nvim-web-devicons

        nvim-highlight-colors

        nvim-treesitter.withAllGrammars

        # plugins/markdown.lua
        render-markdown-nvim
        obsidian-nvim
        markdown-preview-nvim
        no-neck-pain-nvim
      ];
    };
  };
}
