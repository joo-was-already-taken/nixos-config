{ lib, pkgs, config, ... }:
let
  moduleName = "git";
  universityDir = "~/wisdom/pw";
in {
  options.modules.${moduleName}.enable = lib.mkEnableOption moduleName;

  config = lib.mkIf config.modules.${moduleName}.enable {
    # don't use `programs.git`, `extraConfig` doesn't preserve order

    home.packages = with pkgs; [
      git
      diff-so-fancy
    ];

    home.file.".config/git/config".text = ''
      [user]
        name = joo-was-already-taken
        email = trackpointus@protonmail.com

      [init]
        defaultBranch = trunk

      [includeIf "gitdir:${universityDir}/"]
        path = ~/.config/git/config-university

      [core]
        pager = diff-so-fancy | less -RF
        editor = nvim

      [credential]
        helper = cache --timeout=7200

      [alias]
        a = add .
        st = status
        d = diff
        ds = diff --staged
        ci = commit -v
        ch = checkout
        br = branch
        last = log -1 HEAD
    '';

    # to update config-university run `systemctl --user start gitconfig-init.service`
    systemd.user.services."gitconfig-init" = {
      Service.ExecStart = pkgs.writeShellScript "gitconfig-init" ''
        #!/run/current-system/sw/bin/bash
        echo -e "
        [user]
          name = Sebastian Wojciechowski
          email = $(cat ${config.sops.secrets.pw_email.path})
        [init]
          defaultBranch = main
        " > ~/.config/git/config-university
      '';
    };
  };
}
