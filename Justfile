flup:
  nix flake update
hmsw:
  home-manager switch --flake .
nrsw:
  sudo nixos-rebuild switch --flake .
