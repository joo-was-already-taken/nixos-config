{
  den.aspects.librewolf.homeManager = { pkgs, ... }: {
    stylix.targets.librewolf = {
      enable = true;
      profileNames = [ "default" ];
    };
    home.packages = [ pkgs.librewolf ];
    home.file.".librewolf/librewolf.overrides.cfg".text = ''
      defaultPref("webgl.disabled", false);
      defaultPref("content.protectedContent", true);
      defaultPref("privacy.resistFingerprinting", false);
      defaultPref("privacy.clearOnShutdown.history", false);
      defaultPref("privacy.clearOnShutdown.cookies", false);
      defaultPref("network.cookie.lifetimePolicy", 0);
      lockPref("browser.toolbars.bookmarks.visibility", "never");
      lockPref("browser.toolbars.bookmarks.showOtherBookmarks", false);
      lockPref("browser.toolbars.bookmarks.showInPrivateBrowsing", false);
    '';
  };
}
