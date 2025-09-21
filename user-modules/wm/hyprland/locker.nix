{ lib, config, ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };
      listener = [
        {
          timeout = 8 * 60;
          on-timeout = "hyprlock";
        }
        {
          timeout = 10 * 60;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  stylix.targets.hyprlock.enable = false;
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      animations = {
        enabled = true;
        fade_in.bezier = "linear, 1, 1, 0, 0";
        fade_out.bezier = "linear, 1, 1, 0, 0";
      };
      background = lib.mkForce [
        {
          path = builtins.toString config.stylix.image;
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = lib.mkForce [
        {
          monitor = "";
          size = "250, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(${config.lib.stylix.colors.base06})";
          inner_color = "rgb(${config.lib.stylix.colors.base02})";
          outer_color = "rgb(${config.lib.stylix.colors.base04})";
          fail_color = "rgb(${config.lib.stylix.colors.base08})";
          check_color = "rgb(${config.lib.stylix.colors.base0E})";
        }
      ];
      label = [
        {
          monitor = "";
          position = "0, 110";
          font_size = 60;
          text = ''cmd[update:1000] echo "<b><big> $(date +'%H:%M') </big></b>"'';
          color = "rgb(${config.lib.stylix.colors.base06})";
        }
      ];
    };
  };
}
