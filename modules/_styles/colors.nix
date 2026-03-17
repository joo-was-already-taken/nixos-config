lib:
let
  removeHash = color:
      builtins.substring 1 (builtins.stringLength color - 1) color;
  colorschemesRemoveHashes = colorschemes:
    lib.mapAttrs (_: colorscheme:
      lib.mapAttrs (_: color: removeHash color) colorscheme
    ) colorschemes;
  colorsWithHashes = {
    evergarden = {
      base00 = "#1c2225"; # ----
      base01 = "#2b3337"; # ---
      base02 = "#374145"; # --
      base03 = "#4a585c"; # -
      base04 = "#6f8788"; # +
      base05 = "#96b4aa"; # ++
      base06 = "#adc9bc"; # +++
      base07 = "#f8f9e8"; # ++++
      base08 = "#f57f82"; # red
      base09 = "#f7a182"; # orange
      base0A = "#f5d098"; # yellow
      base0B = "#cbe3b3"; # green
      base0C = "#b3e6db"; # aqua/cyan
      base0D = "#b2caed"; # blue
      base0E = "#d2bdf3"; # purple
      base0F = "#b88067"; # brown
    };
  };
in colorschemesRemoveHashes colorsWithHashes
