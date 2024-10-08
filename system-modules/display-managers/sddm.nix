{ userSettings, ... }:

{
  services.displayManager.sddm = {
    enable = true;

    settings = {
      DefaultSession = "hyprland.desktop";
      User = userSettings.userName;

      Wayland = {
        CompositorCommand = "Hyprland";
        EnableHiDPI = true;
        SessionDir = /usr/share/wayland-sessions;
      };
    };
  };
}
