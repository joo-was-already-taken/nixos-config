args:
{
  importNvimColorscheme = pkgs: let
    colorSettings = import ../styling/current-settings.nix args;
  in
    if colorSettings ? nvim then
      colorSettings.nvim pkgs
    else {
      plugins = [];
      config = ''
        return {}
      '';
    };
}
