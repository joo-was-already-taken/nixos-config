{ lib, pkgs, config, sessionVariables, ... }:
let
  moduleName = "nemo";
  terminal = sessionVariables.TERMINAL;
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    home.packages = [ pkgs.nemo ];

    home.file.".local/share/nemo/actions/open_in_${terminal}.nemo_action".text = ''
      [Nemo Action]
      Name=Open in ${terminal}
      Comment=Open '${terminal}' in the selected folder
      Exec=${terminal} -e 'cd %F; zsh'
      Selection=any
      Extensions=dir;
      EscapeSpaces=true
    '';
  };
}
