{ lib, pkgs, ... }:
let 
  templatesDir = "wisdom/.templates";
in {
  home.activation.addObsidianTemplates = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.rsync}/bin/rsync -r --delete $VERBOSE_ARG \
      "${builtins.toPath ./obsidian-templates}/" "$HOME/${templatesDir}"
  '';
}
