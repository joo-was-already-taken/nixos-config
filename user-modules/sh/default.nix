{ ... }@args:

{
  imports = [
    (import ./zsh.nix args)
  ];

  modules.zsh.enable = true;
}
