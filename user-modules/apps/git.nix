{ lib, pkgs, config, ... }:
let
  moduleName = "git";
  universityDir = "wisdom/pw";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    # don't use `programs.git`, `extraConfig` doesn't preserve order

    home.packages = with pkgs; [
      git
    ];

    home.file.".config/git/config".text = ''
      [user]
        name = joo-was-already-taken
        email = trackpointus@protonmail.com

      [includeIf "gitdir:~/${universityDir}/"]
        path = ~/.config/git/config-university
    '';

    systemd.user.services."gitconfig-init" = {
      Service.ExecStart = pkgs.writeShellScript "gitconfig-init" ''
        #!/run/current-system/sw/bin/bash
        echo -e "
        [user]
          name = Sebastian Wojciechowski
          email = $(cat ${config.sops.secrets.pw_email.path})
        " > ~/.config/git/config-university
      '';
    };
  };
}
