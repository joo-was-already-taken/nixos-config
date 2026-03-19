{ inputs, ... }:
let
  getStyle = { host, user }: if user.style != null then user.style else host.style;
  stylixConf = { isHomeManager, host, user }: { lib, pkgs, ... }: let
    style = if isHomeManager then getStyle { inherit host user; } else host.style;
  in {
    enable = true;
    autoEnable = false;

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme.override { color = "black"; };
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    targets = {
      font-packages.enable = true;
      gtk.enable = true;
      qt = {
        enable = true;
        platform = "qtct";
      };
    };

    base16Scheme = style.colors;
    image = style.wallpaper;
    polarity = style.polarity;

    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 32;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
    };

    opacity = {
      applications = 1.0;
      terminal = 0.8;
      desktop = 1.0;
      popups = 1.0;
    };
  } // lib.optionalAttrs (!isHomeManager) {
    homeManagerIntegration.autoImport = false;
  };
in {
  den.aspects.styling = { host, user }: {
    config.lib = { inherit getStyle; };

    # nixos = { lib, pkgs, ... }@args: {
    #   imports = [ inputs.stylix.nixosModules.stylix ];
    #   stylix = stylixConf { isHomeManager = false; inherit host user; } args;
    # };
    homeManager = { lib, pkgs, ... }@args: {
      imports = [ inputs.stylix.homeManagerModules.stylix ];
      stylix = stylixConf { isHomeManager = true; inherit host user; } args;
    };
  };
}
