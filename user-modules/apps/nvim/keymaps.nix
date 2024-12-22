let 
  silent = map (keymap: keymap // {
      options = { noremap = true; silent = true; unique = true; };
    }) [
      # Neotree
      {
        action = "<cmd>Neotree filesystem toggle reveal float<CR>";
        key = "<leader>e";
      }
      {
        action = "<cmd>Neotree git_status toggle reveal float<CR>";
        key = "<leader>g";
      }

      # Quitting
      {
        action = "<cmd>qa<CR>";
        key = "<leader>qq";
      }
      {
        action = "<cmd>wa<CR><cmd>qa<CR>";
        key = "<leader>qw";
      }

      # Search
      {
        action = "<cmd>noh<CR>";
        key = "<leader>h";
      }

      # Navigation
      {
        action = "<C-d>zz";
        key = "<C-d>";
      }
      {
        action = "<C-u>zz";
        key = "<C-u>";
      }

      # Window management
      {
        action = "<cmd>vsplit<CR>";
        key = "<leader>s|";
      }
      {
        action = "<cmd>vsplit<CR>";
        key = "<leader>s-";
      }

      # Indenting
      {
        action = "<gv";
        key = "<";
        mode = "v";
      }
      {
        action = ">gv";
        key = ">";
        mode = "v";
      }
    ];
in silent
