{
  den.aspects.git = { host, user }: {
    homeManager = { lib, pkgs, config, ... }: let
      baseHomeConfig = {
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

          ${
            if user.university.enable then
              ''
                [includeIf "gitdir:${user.university.dir config.home.homeDirectory}/"]
                  path = ~/.config/git/config-university
              ''
            else
              ""
          }

          [diff]
            tool = vimdiff

          [core]
            askPass = ""
            pager = diff-so-fancy | less -RF
            editor = nvim

          [credential]
            helper = cache --timeout=7200
            useHttpPath = true

          [alias]
            a = add
            st = status
            d = diff
            ds = diff --staged
            ci = commit -v
            ch = checkout
            br = branch
            last = log -1 HEAD
        '';

        programs.lazygit = {
          enable = true;
          settings.git = {
            autoFetch = false;
            autoRefresh = false;
            mainBranches = [
              "main"
              "master"
              "trunk"
            ];
          };
        };
      };
      
      universityHomeConfig = lib.optionalAttrs user.university.enable {
        # to update config-university run `systemctl --user start gitconfig-init.service`
        systemd.user.services."gitconfig-init" = {
          Service.ExecStart = pkgs.writeShellScript "gitconfig-init" ''
            echo -e "
            [user]
              name = Sebastian Wojciechowski
              email = $(cat ${"TODO"})
            [init]
              defaultBranch = main
            " > ~/.config/git/config-university
          '';
        };
        # automatically run the above service
        home.activation.addGitConfig = lib.hm.dag.entryAfter [ "writeBoundary" "reloadSystemd" ] ''
          run ${pkgs.systemd}/bin/systemctl $VERBOSE_ARG --user start gitconfig-init.service
        '';
      };
    in
      lib.recursiveUpdate baseHomeConfig universityHomeConfig;
  };
}
