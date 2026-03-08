#  ____,  ____,  __,    _, _,  ____,  ____,  ____,
# (-|  \ (-|_,  (-|    (-|  \ (-(__  (-/  \ (-|__)
#  _|__/  _|__,  _|__,  _|__/  ____)  _\__/, _|  \,
# (      (      (      (      (      (      (
#
# more like `Dellusor`

{ inputs, config, lib, ... }:

let
  host = "delusor";
  mainUser = "joo";
in
{
  flake.nixosConfigurations.${host} = lib.nixosSystem {
    system = "x86_64-linux";
    # modules = inputs.self.presets.core;
  };

  flake.homeConfigurations.${mainUser} = inputs.home-manager.lib.homeManagerConfiguration {
  };
}
