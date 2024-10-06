{ ... }:

{
  programs.firefox = {
    enable = true;

    # languagePacks = [ "en-US" "pl" "de" ];

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptominig = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # possible: "never", "always", "newtab"
      DisplayMenuBar = "default-off"; # possible: "default-off", "always", "never", "default-on"
      SearchBar = "unified"; # possible: "unified", "separate"

      ExtensionSettings = {
        "*".installation_mode = "blocked";
      };
    };
  };
}
