{ lib, ... }:

let
  removeHash = color:
    builtins.substring 1 (builtins.stringLength color - 1) color;
  colorschemesRemoveHashes = colorschemes:
    lib.mapAttrs (_: colorscheme:
      lib.mapAttrs (_: color: removeHash color) colorscheme
    ) colorschemes;
  colorsWithHashes = {
    # Gruvbox dark, pale
    # Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox);
    gruvbox = {
      base00 = "#262626"; # ----
      base01 = "#3a3a3a"; # ---
      base02 = "#4e4e4e"; # --
      base03 = "#8a8a8a"; # -
      base04 = "#949494"; # +
      base05 = "#dab997"; # ++
      base06 = "#d5c4a1"; # +++
      base07 = "#ebdbb2"; # ++++
      base08 = "#d75f5f"; # red
      base09 = "#ff8700"; # orange
      base0A = "#ffaf00"; # yellow
      base0B = "#afaf00"; # green
      base0C = "#85ad85"; # aqua/cyan
      base0D = "#83adad"; # blue
      base0E = "#d485ad"; # purple
      base0F = "#d65d0e"; # brown
    };

    shub = {
      base00 = "#262626"; # ----
      base01 = "#3a3a3a"; # ---
      base02 = "#4e4e4e"; # --
      base03 = "#8a8a8a"; # -
      base04 = "#949494"; # +
      base05 = "#dab997"; # ++
      base06 = "#d5c4a1"; # +++
      base07 = "#ebdbb2"; # ++++
      base08 = "#d68477"; # red
      base09 = "#eaa54f"; # orange
      base0A = "#e5ab63"; # yellow
      base0B = "#c1b94d"; # green
      base0C = "#a5b690"; # aqua/cyan
      base0D = "#a4b6a8"; # blue
      base0E = "#bf8d9c"; # purple
      base0F = "#d68d52"; # brown
    };

    tokyonight = {
      base00 = "#1d202f"; # ----
      base01 = "#292e42"; # ---
      base02 = "#434960"; # --
      base03 = "#606782"; # -
      base04 = "#868eae"; # +
      base05 = "#a9b1d6"; # ++
      base06 = "#c0caf5"; # +++
      base07 = "#d1d8f9"; # ++++
      base08 = "#f7768e"; # red
      base09 = "#ff9e64"; # orange
      base0A = "#e0af68"; # yellow
      base0B = "#9ece6a"; # green
      base0C = "#7dcfff"; # aqua/cyan
      base0D = "#7aa2f7"; # blue
      base0E = "#bb9af7"; # purple
      base0F = "#b2a2a1"; # brown
    };

    miasma = {
      base00 = "#222222"; # ----
      base01 = "#3d3a31"; # ---
      base02 = "#615b44"; # --
      base03 = "#7c7352"; # -
      base04 = "#bcac74"; # +
      base05 = "#d7c483"; # ++
      base06 = "#cac39e"; # +++
      base07 = "#c2c2b0"; # ++++
      base08 = "#b36d43"; # red
      base09 = "#bb7744"; # orange
      base0A = "#c9a554"; # yellow
      base0B = "#78824b"; # green
      base0C = "#57875f"; # aqua/cyan
      base0D = "#688c87"; # blue
      base0E = "#916343"; # purple
      base0F = "#685742"; # brown
    };

    evergarden = {
      base00 = "#1C2225"; # ----
      base01 = "#2B3337"; # ---
      base02 = "#374145"; # --
      base03 = "#4A585C"; # -
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
