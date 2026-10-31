{ pkgs, cosmic-source, ... }:
let
  cosmicPkgs = import cosmic-source { system = pkgs.stdenv.hostPlatform.system; };
  clipboardManager = cosmicPkgs.callPackage ../packages/cosmic-clipboard-manager.nix { };
in {
  environment.systemPackages = [
    pkgs.cosmic-ext-tweaks
    pkgs.cosmic-ext-applet-minimon
    pkgs.cosmic-ext-applet-caffeine
    clipboardManager
  ];
  # Required by the clipboard history applet to observe clipboard changes.
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";
}
