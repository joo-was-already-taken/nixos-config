{ ... }:

{
  flake.modules.nixos.nix = { settings, ... }: {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      trusted-users = [ "root" settings.primaryUser ];
    };
    nix.daemonCPUSchedPolicy = "idle";
    nix.daemonIOSchedClass = "idle";
  };

  flake.modules.homeManager.nix = { pkgs, ... }: {
    nix = {
      package = pkgs.nix;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      settings.auto-optimise-store = true;
    };
  };
}
