{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python312.withPackages (pyPkgs: with pyPkgs; [
          numpy
          scipy
          matplotlib
          ipykernel
        ]);
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            python
          ];
        };
      });
}
