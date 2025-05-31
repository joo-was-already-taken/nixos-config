# NixOS Config
```nix
{
  description = "My personal NixOS-and-HomeManager flake";
}
```
------------
My first NixOS and Home Manager configuration.  
**Warning:** *This config may break and will break!*  
The project's structure is inspired by [librephoenix' config](https://github.com/librephoenix/nixos-config).
It is broken up into five main directories: *user-modules*, *system-modules*, *profiles*, *hosts* and *styling*.
- *user-modules/* - Modules imported by home manager
- *system-modules/* - Modules imported from *configuration.nix*
- *profiles/* - Different profiles such as *work* or *personal*, that's where *configuration.nix* and *home.nix* live
- *hosts/* - Directory for *hardware-configuration.nix* files
- *styling/* - Directory with different styles utilizing [stylix](https://github.com/danth/stylix)
In *flake.nix* you can specify which host and profile as well as username to use (this is a one-user system config).

### Highlights
- WM: [Hyprland](https://hyprland.org)
- Editor: [Neovim](https://neovim.io)
- Terminal emulator: [Ghostty](https://ghostty.org)
- Styling: [Stylix](https://github.com/danth/stylix)
