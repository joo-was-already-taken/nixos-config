{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # python
    python313
  ];
}
