{ lib, pkgs, config, ... }:
let
  moduleName = "qutebrowser";
in {
  options.modules.${moduleName} = {
    enable = lib.mkEnableOption moduleName;
    
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

  config = lib.mkIf config.modules.${moduleName}.enable {
    stylix.targets.qutebrowser.enable = false;

    programs.qutebrowser = {
      enable = true;
      package = pkgs.qutebrowser;

      aliases = {
        adblock = "set content.blocking.enabled";
        darkmode = "set colors.webpage.darkmode.enabled";
      };

      settings = {
        content.blocking.enabled = true;
        scrolling.bar = "when-searching";
        tabs.max_width = 240;
        colors = {
          webpage.darkmode.enabled = false;
        } // config.modules.${moduleName}.colors;
      };

      # extraConfig = /*python*/ ''
      #   import os
      #   default_file_manager = os.environ.get('FILEMANAGER', 'nemo')
      #   c.fileselect.handler = 'external'
      #   c.fileselect.single_file.command = [default_file_manager]
      #   c.fileselect.multiple_files.command = [default_file_manager]
      #   c.fileselect.folder.command = [default_file_manager]
      # '';
    };

    xdg = {
      desktopEntries = {
        qutebrowser = {
          name = "qutebrowser";
          exec = "${config.programs.qutebrowser.package}/bin/qutebrowser";
        };
      };
    };
  };
}
