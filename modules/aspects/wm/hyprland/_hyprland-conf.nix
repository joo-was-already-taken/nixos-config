{ user, args, colors, floatingAppsClasses }:

let
  inherit (args) config lib pkgs;

  floatingWindowSize = "1300 800";

  toggleFloating = pkgs.writeShellApplication {
    name = "hypr-toggle-floating";
    text = ''
      hyprctl dispatch togglefloating
      floating=$(hyprctl activewindow | awk '/floating:/ {print $2}')
      if [ "$floating" == "1" ]; then
        hyprctl dispatch resizeactive exact ${floatingWindowSize}
        hyprctl dispatch centerwindow 1
      fi
    '';
  };
  changeKbLayout = pkgs.writeShellApplication {
    name = "change-kb-layout";
    runtimeInputs = [ pkgs.libnotify ];
    text = ''
      for kb in $(hyprctl devices | awk '/Keyboard at/ {getline; print $1}'); do
        hyprctl switchxkblayout "$kb" next
      done
      layout_info="$(hyprctl devices | grep -i at-translated-set-2-keyboard -A 2)"
      cur_layout_idx="$(echo "$layout_info" | tail -n1 | cut -f4 -d' ')"
      langs="$(echo "$layout_info" | grep -o 'l "[^"]*"' | grep -o '"[^"]*"' | tr -d '"')"
      IFS=',' read -r -a lang_arr <<< "$langs"
      cur_lang=''${lang_arr[$cur_layout_idx]}
      notify-send "Keyboard layout: $cur_lang"
    '';
  };
  toggleMainDisplay = pkgs.writeShellApplication {
    name = "toggle-main-display";
    runtimeInputs = [ pkgs.wlr-randr ];
    text = ''
      display="$(wlr-randr | head -n1 | awk '{print $1}')"
      hyprctl dispatch dpms toggle "$display"
    '';
  };
in
''
  debug:disable_logs = true
  ecosystem {
    no_update_news = false
    no_donation_nag = true
  }

  $mod = SUPER
  $terminal = ${user.guiApps.terminal}
  $fileManager = ${user.guiApps.fileManager}
  $browser = ${user.guiApps.browser}

  $menu = ${pkgs.rofi}/bin/rofi -show drun -show-icons
  $commandMenu = ${pkgs.rofi}/bin/rofi -show run

  exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet &
  exec-once = (sleep 1; ${pkgs.blueman}/bin/blueman-tray) &

  monitor = , preferred, auto, 1

  env = XCURSOR_SIZE, ${builtins.toString config.stylix.cursor.size}
  env = HYPRCURSOR_SIZE, ${builtins.toString config.stylix.cursor.size}

  env = HYPRSHOT_DIR, ${config.xdg.userDirs.pictures}/screenshots

  general {
    gaps_in = 5
    gaps_out = 20
    border_size = 2

    col.active_border = rgb(${colors.activeBorder1}) rgb(${colors.activeBorder2}) 45deg
    col.inactive_border = rgba(00000000)

    resize_on_border = true

    allow_tearing = false

    layout = "master"
  }

  decoration {
    rounding = 0
    active_opacity = 1.0
    inactive_opacity = 1.0

    blur {
      enabled = true
      size = 5
      passes = 3

      vibrancy = 0.4
    }
  }

  animations {
    enabled = true

    bezier = easeOutQuint, 0.23, 1, 0.32, 1
    bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
    bezier = linear, 0, 0, 1, 1
    bezier = almostLinear, 0.5, 0.5, 0.75, 1.0
    bezier = quick, 0.15, 0, 0.1, 1

    animation = global, 1, 10, default
    animation = border, 1, 5.39, easeOutQuint
    animation = windows, 1, 4.79, easeOutQuint
    animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
    animation = windowsOut, 1, 1.49, linear, popin 87%
    animation = fadeIn, 1, 1.73, almostLinear
    animation = fadeOut, 1, 1.46, almostLinear
    animation = fade, 1, 3.03, quick
    animation = layers, 1, 3.81, easeOutQuint
    animation = layersIn, 1, 4, easeOutQuint, fade
    animation = layersOut, 1, 1.5, linear, fade
    animation = fadeLayersIn, 1, 1.79, almostLinear
    animation = fadeLayersOut, 1, 1.39, almostLinear
    animation = workspaces, 1, 1.4, easeInOutCubic
    # animation = workspacesIn, 1, 1.21, almostLinear, fade
    # animation = workspacesOut, 1, 1.94, almostLinear, fade
  }

  dwindle {
    pseudotile = true
    preserve_split = true
  }

  master {
    new_status = master
  }

  misc {
    force_default_wallpaper = -1
    disable_hyprland_logo = true
    disable_splash_rendering = true

    focus_on_activate = true

    initial_workspace_tracking = 1

    vfr = true
  }

  ${
    let
      lines = map
        (cls: "windowrule = match:class ${cls}, float on, center on, size ${floatingWindowSize}")
        floatingAppsClasses;
    in builtins.concatStringsSep "\n" lines
  }

  workspace = w[tv1], gapsout:0, gapsin:0
  workspace = f[1], gapsout:0, gapsin:0
  windowrule = match:workspace w[tv1], match:float false, border_size 0, rounding 0
  windowrule = match:workspace f[1], match:float false, border_size 0, rounding 0

  cursor {
    inactive_timeout = 16
    no_warps = true
  }

  input {
    kb_layout = pl,de
    kb_variant = ,us # use sane german
    # kb_options = grp:win_space_toggle # already have a script for that

    follow_mouse = 1
    mouse_refocus = 0

    sensitivity = 0

    touchpad {
      natural_scroll = true
    }
  }

  gestures {
    workspace_swipe_touch = false
  }

  bind = $mod, F, exec, $browser
  bind = $mod, return, exec, $terminal
  bind = $mod, C, killactive
  bind = SUPER_SHIFT, C, forcekillactive
  bind = $mod, Q, exit
  bind = $mod, E, exec, $fileManager
  bind = $mod, D, exec, $menu
  bind = $mod, R, exec, $commandMenu
  bind = $mod, O, fullscreen, 0 # fullscreen
  bind = $mod, U, fullscreen, 1 # maximize
  bind = $mod, I, exec, ${lib.getExe toggleFloating}
  bind = $mod, Y, fullscreenstate, 0 3

  bind = $mod, backslash, exec, ${lib.getExe toggleMainDisplay}

  # change keyboard layout
  bind = $mod, space, exec, ${lib.getExe changeKbLayout}

  # Take a screenshot of an entire monitor
  bind = , Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m output
  # Take a screenshot of selected region
  bind = Control_L&Control_R, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region

  # Volume Control
  bind = $mod, M, exec, ${pkgs.pavucontrol}/bin/pavucontrol

  # Color picker
  bind = $mod, minus, exec, ${pkgs.wl-color-picker}/bin/wl-color-picker

  bind = $mod, H, movefocus, l
  bind = $mod, L, movefocus, r
  bind = $mod, K, movefocus, u
  bind = $mod, J, movefocus, d
  bind = $mod, semicolon, cyclenext
  bind = $mod, semicolon, alterzorder, top

  bind = $mod SHIFT, H, movewindow, l
  bind = $mod SHIFT, L, movewindow, r
  bind = $mod SHIFT, K, movewindow, u
  bind = $mod SHIFT, J, movewindow, d

  bind = $mod, N, workspace, +1
  bind = $mod, P, workspace, -1
  bind = $mod SHIFT, N, movetoworkspace, +1
  bind = $mod SHIFT, P, movetoworkspace, -1
  ${ # generate workspace bindings for workspaces 1 - 10
    let
      bindWorkspace = ws: let
        idx = ws - 1;
      in [
        "bind = $mod, code:1${toString idx}, workspace, ${toString ws}"
        "bind = $mod SHIFT, code:1${toString idx}, movetoworkspace, ${toString ws}"
      ];
      workspacesBinds = builtins.genList (idx: bindWorkspace (idx + 1)) 10;
    in
      builtins.concatStringsSep "\n" (builtins.concatLists workspacesBinds)
  }

  # sound controls
  binde = , XF86AudioRaiseVolume, exec, ${pkgs.pulsemixer}/bin/pulsemixer --change-volume +5 --max-volume 155
  binde = , XF86AudioLowerVolume, exec, ${pkgs.pulsemixer}/bin/pulsemixer --change-volume -5
  binde = , XF86AudioMute, exec, ${pkgs.pulsemixer}/bin/pulsemixer --toggle-mute

  # brightness controls (backlight)
  binde = , XF86MonBrightnessUP, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +10%
  binde = , XF86MonBrightnessDOWN, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%-

  bindm = $mod, mouse:272, movewindow

  group {
    auto_group = false

    col.border_active = rgb(${colors.groupActive})
    col.border_inactive = rgba(${colors.groupActive}80)
    col.border_locked_active = rgb(${colors.groupActive})
    col.border_locked_inactive = rgba(${colors.groupActive}80)

    groupbar {
      font_size = 13
      font_family = monospace
      font_weight_active = heavy
      font_weight_inactive = normal
      indicator_gap = 0
      height = 22
      gaps_in = 5
      gaps_out = 0

      col.active = rgb(${colors.groupActive})
      col.inactive = rgba(${colors.groupActive}80)
      col.locked_active = rgb(${colors.groupActive})
      col.locked_inactive = rgba(${colors.groupActive}80)
    }
  }

  # resize submap
  bind = $mod, S, submap, resize
  submap = resize
  binde = , H, resizeactive, -80 0
  binde = , L, resizeactive, 80 0
  binde = , K, resizeactive, 0 -80
  binde = , J, resizeactive, 0 80
  bind = , escape, submap, reset
  bind = Control_L, bracketleft, submap, reset
  bind = , catchall, submap, reset
  submap = reset

  # group submap
  bind = $mod, G, submap, group
  submap = group
  bind = , G, exec, hyprctl dispatch submap reset; hyprctl dispatch togglegroup
  bind = , H, exec, hyprctl dispatch submap reset; hyprctl dispatch moveintogroup l
  bind = , L, exec, hyprctl dispatch submap reset; hyprctl dispatch moveintogroup r
  bind = , K, exec, hyprctl dispatch submap reset; hyprctl dispatch moveintogroup u
  bind = , J, exec, hyprctl dispatch submap reset; hyprctl dispatch moveintogroup d
  bind = , O, exec, hyprctl dispatch submap reset; hyprctl dispatch moveoutofgroup
  bind = , N, exec, hyprctl dispatch submap reset; hyprctl dispatch changegroupactive n
  bind = , P, exec, hyprctl dispatch submap reset; hyprctl dispatch changegroupactive b

  bind = $mod, N, changegroupactive, n
  bind = $mod, P, changegroupactive, b

  bind = , M, submap, move_group_window
  bind = $mod, M, submap, move_group_window

  bind = , escape, submap, reset
  bind = Control_L, bracketleft, submap, reset
  bind = , catchall, submap, reset
  submap = reset

  # move_group_window submap
  bind = $mod SHIFT, G, submap, move_group_window
  submap = move_group_window
  bind = , N, exec, hyprctl dispatch submap reset; hyprctl dispatch movegroupwindow n
  bind = , P, exec, hyprctl dispatch submap reset; hyprctl dispatch movegroupwindow b
  bind = SHIFT, N, movegroupwindow, n
  bind = SHIFT, P, movegroupwindow, b

  bind = , escape, submap, reset
  bind = Control_L, bracketleft, submap, reset
  bind = SHIFT, catchall, submap, reset
  submap = reset
''
