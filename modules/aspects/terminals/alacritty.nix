{
  den.aspects.alacritty.homeManager = { lib, config, ... }: {
    stylix.targets.alacritty.enable = true;

    programs.alacritty = {
      enable = true;

      settings = {
        env.TERM = "xterm-256color";

        scrolling.multiplier = 8;

        window.padding = {
          x = 2;
          y = 2;
        };
        window.dimensions = {
          columns = 120;
          lines = 32;
        };

        colors.primary.foreground = lib.mkForce
          config.lib.stylix.colors.withHashtag.base06;
      };
    };
  };
}
