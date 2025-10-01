{ pkgs, ... }:

{
  # environment.systemPackages = with pkgs; [
  #   sddm-astronaut
  # ];
  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  #   package = pkgs.kdePackages.sddm;
  #   theme = "sddm-astronaut-theme";
  #   extraPackages = with pkgs.kdePackages; [
  #     qtmultimedia
  #   ];
  # };

  environment.systemPackages = with pkgs; [
    where-is-my-sddm-theme
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "where_is_my_sddm_theme";
  };
}
