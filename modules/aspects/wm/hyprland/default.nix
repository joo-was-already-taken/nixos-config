{ inputs, ... }:
{
  den.aspects.hyprland = { host, user }: {
    nixos = { pkgs, ... }: {
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };

      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      };
    };

    homeManager = { config, pkgs, ... }@args: {
      home.packages = with pkgs; [
        wl-clipboard
        pulsemixer
        pavucontrol
        wlr-randr
        networkmanagerapplet
        libnotify
        wlr-layout-ui
      ];

      services.mako = {
        enable = true;
        settings.default-timeout = 4000;
      };

      services.hyprpaper = let
        wallpaper = builtins.toString config.stylix.image;
      in {
        enable = true;
        settings = {
          preload = [ wallpaper ];
          wallpaper = [ ", ${wallpaper}" ];
        };
      };

      home.sessionVariables.NIXOS_OZONE_WL = "1";
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd = {
          enable = true;
          variables = [ "--all" ];
        };
        package = null;
        portalPackage = null;

        extraConfig = import ./_hyprland-conf.nix {
          inherit user args;
          colors = with config.lib.stylix.colors; {
            activeBorder1 = base0D;
            activeBorder2 = base0C;
            groupActive = base0E;
          };
          floatingAppsClasses = [
            "nemo"
            "org.pulseaudio.pavucontrol"
            ".blueman-manager-wrapped"
            "WLR Layout"
          ];
        };
      };
    };
  };
}
