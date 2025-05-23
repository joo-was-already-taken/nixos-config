{ pkgs, ... }:
{
  memory = pkgs.writeShellApplication {
    name = "ironbar-memory";
    text = builtins.readFile ./memory.sh;
  };
}
