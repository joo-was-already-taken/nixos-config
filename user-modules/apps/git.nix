{ lib, pkgs, config, ... }:
let
  moduleName = "git";
  universityDir = "wisdom/pw";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    programs.git = {
      enable = true;
      userName = "joo-was-already-taken";
      userEmail = "trackpointus@protonmail.com";

      extraConfig = {
        "includeIf \"gitdir:~/${universityDir}/\"".path = "~/${universityDir}/.gitconfig";
      };
    };

    systemd.user.services."gitconfig-init" = {
      Service.ExecStart = pkgs.writeShellScript "gitconfig-init" ''
        #!/run/current-system/sw/bin/bash
        echo "
        [user]
          name = Sebastian Wojciechowski
          email = $(cat ${config.sops.secrets.pw_email.path})
        " > ~/${universityDir}/.gitconfig
      '';
    };
  };
}
