{ den, ... }:
{
  den.hosts.x86_64-linux.rednub = {
    stateVersion = "26.05";
    users.joo = {
      trusted = true;
    };
  };

  den.aspects.joo = {
    includes = with den.aspects; [
      base
      base._.nix
      base._.locale
      base._.networking
      zsh
      git
      tmux
      user-dirs
      neovim
    ];
  };

  den.aspects.rednub = {
    includes = with den.aspects; [
      base
      base._.nix
      base._.locale
      base._.networking
    ];

    nixos = {
      imports = [ ./_hardware/rednub.nix ];

      boot.loader.grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
      };
      services.logind = {
        lidSwitch = "ignore";
        lidSwitchExternalPower = "ignore";
        lidSwitchDocked = "ignore";
      };

      services.openssh.enable = true;
    };
  };
}
