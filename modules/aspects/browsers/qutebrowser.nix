{ den, ... }:
{
  den.aspects.qutebrowser = {
    includes = [
      (den.provides.unfree [ "widevine-cdm" ])
    ];

    homeManager = { lib, config, pkgs, ... }: let
      flattenAttrs = let
        flattenAttrsRec = prefix: set: let
          concatFn = key: let
            value = set.${key};
            path = if prefix == "" then key else "${prefix}.${key}";
        in
          if builtins.isAttrs value && !lib.isDerivation value then
            flattenAttrsRec path value
          else
            [ { inherit path value; } ];
      in
        lib.concatMap concatFn (builtins.attrNames set);
      in flattenAttrsRec "";

      colorsPy = config.qutebrowser-config.colors
        |> flattenAttrs
        |> map ({ path, value }: "c.colors.${path} = '${value}'")
        |> builtins.concatStringsSep "\n";

      configPy = /*python*/ ''
        config.load_autoconfig(True)

        c.aliases['adblock'] = 'set content.blocking.enabled'
        c.aliases['darkmode'] = 'config-cycle colors.webpage.darkmode.enabled true false'

        c.content.blocking.enabled = True
        c.content.pdfjs = False
        c.scrolling.bar = 'when-searching'
        c.tabs.max_width = 240
        c.colors.webpage.darkmode.enabled = False

        c.content.javascript.clipboard = 'access'

        c.bindings.commands = {
          'command': {
            '<Ctrl-N>': 'completion-item-focus next',
            '<Ctrl-P>': 'completion-item-focus prev',
          },
        }

        font_setting = '10pt monospace'
        c.fonts.statusbar = font_setting
        c.fonts.tabs.selected = font_setting
        c.fonts.tabs.unselected = font_setting
        c.fonts.hints = f'bold {font_setting}'
        c.fonts.keyhint = font_setting
        c.fonts.messages.info = font_setting
        c.fonts.messages.warning = font_setting
        c.fonts.messages.error = font_setting
        c.fonts.completion.entry = font_setting
        c.fonts.completion.category = f'bold {font_setting}'
      '';
    in {
      config = {
        stylix.targets.qutebrowser.enable = false;
        home.packages = [
          (pkgs.qutebrowser.override { enableWideVine = true; })
        ];
        xdg.configFile."qutebrowser/config.py".text = configPy + "\n" + colorsPy;
      };

      options.qutebrowser-config = {
        # default colors from stylix
        colors = with config.lib.stylix.colors.withHashtag; lib.mkOption {
          type = lib.types.attrs;
          default = {
            webpage.preferred_color_scheme = config.stylix.polarity;
            statusbar = {
              insert.fg = base07;
              insert.bg = base01;

              normal.fg = base07;
              command.fg = base07;
              command.private.fg = base07;

              url.fg = base07;
              url.success.http.fg = base07;
              url.success.https.fg = base07;
            };
            contextmenu = {
              disabled.fg = base07;
              menu.fg = base07;
              selected.fg = base07;
            };
            tabs = {
              bar.bg = base00;
              even.bg = base01;
              even.fg = base07;
              odd.bg = base01;
              odd.fg = base07;
              selected = {
                even.bg = base03;
                even.fg = base07;
                odd.bg = base03;
                odd.fg = base07;
              };
            };

            completion.fg = base05;
            completion.odd.bg = base01;
            completion.even.bg = base00;
            completion.category.fg = base0A;
            completion.category.bg = base00;
            completion.category.border.top = base00;
            completion.category.border.bottom = base00;
            completion.item.selected.fg = base05;
            completion.item.selected.bg = base02;
            completion.item.selected.border.top = base02;
            completion.item.selected.border.bottom = base02;
            completion.item.selected.match.fg = base0B;
            completion.match.fg = base0B;
            completion.scrollbar.fg = base05;
            completion.scrollbar.bg = base00;
            contextmenu.disabled.bg = base01;
            # contextmenu.disabled.fg = base04;
            contextmenu.menu.bg = base00;
            # contextmenu.menu.fg =  base05;
            contextmenu.selected.bg = base02;
            # contextmenu.selected.fg = base05;
            downloads.bar.bg = base00;
            downloads.start.fg = base00;
            downloads.start.bg = base0D;
            downloads.stop.fg = base00;
            downloads.stop.bg = base0C;
            downloads.error.fg = base08;
            hints.fg = base00;
          };
        };
      };
    };
  };
}
