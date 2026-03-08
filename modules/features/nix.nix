{ ... }:

{
  flake.modules.nixos.nix = { settings, ... }: {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      trusted-users = [ "root" settings.primaryUser ];

      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    nix.daemonCPUSchedPolicy = "idle";
    nix.daemonIOSchedClass = "idle";
  };

  flake.modules.homeManager.nix = {
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      settings.auto-optimise-store = true;
    };
  };
}
