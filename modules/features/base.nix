{
  flake.modules.nixos.base = { pkgs, lib, settings, ... }: {
    # uninstall preinstalled garbage
    programs.nano.enable = false;
    services.xserver = {
      enable = lib.mkDefault false;
      desktopManager.xterm.enable = false;
      excludePackages = [ pkgs.xterm ];
    };

    users.users.${settings.primaryUser} = {
      isNormalUser = true;
      description = settings.primaryUser;
      extraGroups = [ "networkmanager" "wheel" ];
    };

    console.keyMap = "pl2";

    environment.systemPackages = with pkgs; [
      vim
      git
      wget
      zip
      unzip
    ];

    environment.sessionVariables = {
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";
    };

    system.stateVersion = settings.stateVersion;
  };

  flake.modules.homeManager.base = { settings, ... }: {
    programs.home-manager.enable = true;
    home = rec {
      username = settings.primaryUser;
      homeDirectory = "/home/${username}";
      inherit (settings) stateVersion;
    };
  };
}
