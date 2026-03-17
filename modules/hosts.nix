{ den, ... }: {
  den.hosts.x86_64-linux.rednub = {
    stateVersion = "26.05";
    users.joo = {
      trusted = true;
      hasGui = true;
      guiApps = {
        terminal = "alacritty";
        fileManager = "nemo";
        browser = "qutebrowser";
      };
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
      hyprland
      styling
      alacritty
      ghostty
    ];

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ nemo qutebrowser ];
    };
  };

  den.aspects.rednub = {
    includes = with den.aspects; [
      base
      base._.nix
      base._.locale
      base._.networking
      sddm
      styling
      hyprland
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
