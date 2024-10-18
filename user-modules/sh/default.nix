{ lib, ... }@args:

{
  imports = [
    (import ./zsh.nix args)
  ];

  modules.zsh.enable = lib.mkDefault true;
}
