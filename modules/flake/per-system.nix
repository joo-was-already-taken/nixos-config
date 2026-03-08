{ inputs, ... }:
{
  perSystem = { system, ... }: {
    legacyPackages = {
      unstable = import inputs.nixpkgs-unstable { inherit system; };
    };
  };
}
