{
  den.aspects.nemo = { host, user }: {
    homeManager = { config, pkgs, ... }: let
      inherit (user.guiApps) terminal;
    in {
      home.packages = [ pkgs.nemo ];
      home.file."${config.xdg.dataHome}/nemo/actions/open_in_${terminal}.nemo_action".text = ''
        [Nemo Action]
        Name=Open in ${terminal}
        Comment=Open '${terminal}' in the selected folder
        Exec=${terminal} -e 'cd %F; zsh'
        Selection=any
        Extensions=dir;
        EscapeSpaces=true
      '';
    };
  };
}
