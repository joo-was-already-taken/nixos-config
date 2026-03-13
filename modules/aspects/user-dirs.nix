{
  den.aspects.user-dirs = { host, user }: {
    homeManager = { config, ... }: let
      homeDir = config.home.homeDirectory;
    in {
      xdg.userDirs = {
        enable = true;
        createDirectories = true;

        download = "${homeDir}/downloads";
        music = "${homeDir}/music";
        pictures = "${homeDir}/pictures";
        videos = "${homeDir}/videos";

        desktop = null;
        documents = null;
        publicShare = null;
        templates = null;
      };
    };
  };
}
