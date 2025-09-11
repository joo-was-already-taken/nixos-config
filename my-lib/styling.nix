args:
{
  # importNvimColorscheme = vimPlugins: let
  #   currentSettings = import ../styling/current-settings.nix;
  #   lua = str: "lua << EOF\n${str}\nEOF\n";
  # in lib.mkIf (currentSettings ? nvim) (
  #   let 
  #     colorscheme = currentSettings.nvim vimPlugins;
  #   in {
  #     plugin = colorscheme.plugin;
  #     config = lua colorscheme.config;
  #   }
  # );
  importNvimColorscheme = vimPlugins: let
    colorSettings = import ../styling/current-settings.nix args;
  in
    if colorSettings ? nvim then
      colorSettings.nvim vimPlugins
    else {
      plugins = [];
      config = ''
        return {}
      '';
    };
}
