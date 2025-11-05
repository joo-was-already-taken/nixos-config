{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kvmtool
    qemu_full
  ];

  programs.distrobox.enable = true;
}
