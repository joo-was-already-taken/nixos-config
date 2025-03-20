{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # python
    (python312.withPackages (pyPkgs: with pyPkgs; [
      numpy
      scipy
      matplotlib
      ipykernel
    ]))
  ];
}
