{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { flake-parts, import-tree, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = (import-tree ./modules).imports ++ [ flake-parts.flakeModules.modules ];
    };
}
