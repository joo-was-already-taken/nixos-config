{ ... }@args:

{
  imports = [
    (import ./zsh.nix args)
    ./atuin.nix
  ];

  modules.zsh.enable = true;
  modules.atuin = {
    enable = false;
    enableZshIntegration = true;
  };
}
