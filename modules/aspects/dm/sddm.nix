{
  den.aspects.sddm.nixos = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.where-is-my-sddm-theme ];
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [
        qt6.qt5compat
      ];
      theme = "where_is_my_sddm_theme";
    };
  };
}
