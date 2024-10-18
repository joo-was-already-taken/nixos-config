{ lib, config, ... }:
let
  moduleName = "tmux";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.tmux.enable = true;
    home.file.".config/tmux".source = ./.;
  };
}
