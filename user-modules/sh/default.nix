{ ... }@args:

{
  imports = [
    (import ./zsh.nix args)
    ./atuin.nix
  ];

  modules.zsh.enable = true;
  modules.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
}
