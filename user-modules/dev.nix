{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # python
    (python313.withPackages (ps: with ps; [
      matplotlib
      numpy
      scipy
    ]))

    # linux c man pages
    man-pages
  ];
}
