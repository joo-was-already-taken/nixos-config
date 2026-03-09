topArgs:
{
  createHost = {
    name,
    primaryUser,
    system ? "x86_64-linux",
    timeZone ? "Europe/Warsaw",
    inputs,
    nixpkgs,
    home-manager,
    pkgs,
    stateVersion,
    modules,
    extraNixosModules ? [],
    extraHomeManagerModules ? [],
  }: let
    inherit (nixpkgs) lib;
    settings = {
      hostName = name;
      inherit primaryUser timeZone stateVersion;
    };
    nixosModules = modules
      |> map (mod: topArgs.inputs.self.modules.nixos.${mod} or {})
      |> (mods: mods ++ extraNixosModules);
    homeManagerModules = modules
      |> map (mod: topArgs.inputs.self.modules.homeManager.${mod} or {})
      |> (mods: mods ++ extraHomeManagerModules);
  in {
    nixosConfigurations.${name} = lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs settings; };
      modules = nixosModules;
    };
    homeConfigurations.${primaryUser} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs settings; };
      modules = homeManagerModules;
    };
  };
}
