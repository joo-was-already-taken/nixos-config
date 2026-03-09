let
  bundles = {
    core = [ "base" "locale" "networking" "nix" "zsh" "git" "tmux" ];
  };
  transform = bundleName: modules: {
    inherit modules;
    without = subtrahends: builtins.filter (x: !builtins.elem x subtrahends) modules;
  };
in builtins.mapAttrs transform bundles
