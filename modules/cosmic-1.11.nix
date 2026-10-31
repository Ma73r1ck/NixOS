{ pkgs, lib, cosmic-source, ... }:
let
  cosmicPkgs = import cosmic-source {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  cosmicNames = builtins.filter
    (name: lib.hasPrefix "cosmic-" name || builtins.elem name [
      "pop-launcher" "xdg-desktop-portal-cosmic"
    ])
    (builtins.attrNames cosmicPkgs);
in {
  disabledModules = [ "services/desktop-managers/cosmic.nix" ];
  imports = [ ./cosmic-desktop-backport.nix ];
  nixpkgs.overlays = [
    (final: prev: lib.genAttrs cosmicNames (name: builtins.getAttr name cosmicPkgs))
  ];
  services.desktopManager.cosmic.enable = true;
  assertions = map (name: {
    assertion = lib.getVersion (builtins.getAttr name pkgs) == "1.11.0";
    message = "Expected COSMIC 1.11.0 for " + name;
  }) [ "cosmic-session" "cosmic-comp" "cosmic-panel" "cosmic-settings" ];
}
