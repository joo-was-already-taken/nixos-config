{ inputs, ... }@args:

{
  flake.capabilties.gui = true;

  flake.modules.nixos.hyprland = {
    programs.hyprland = { pkgs, ... }: {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
  };
  flake.modules.home.hyprland = { pkgs, ... }@homeArgs: {
    home.packages = with pkgs; [
      rofi
    ];

    services.mako = {
      enable = true;
      settings.default-timeout = 4000;
    };

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
        moduleArgs = args;
        homeArgs = homeArgs;
      };
    };
  };
}
