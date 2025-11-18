{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kvmtool
    qemu_full

    # virtualbox
  ];

  programs.distrobox.enable = true;
}
