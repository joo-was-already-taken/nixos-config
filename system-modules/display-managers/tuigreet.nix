{ pkgs, userSettings, session, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${session}";
        user = userSettings.userName;
      };
    };
  };
}
