{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kvmtool
    qemu_full
  ];
}
