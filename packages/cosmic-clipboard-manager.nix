{ lib, rustPlatform, fetchFromGitHub, libcosmicAppHook, pkg-config, openssl, sqlite }:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-clipboard-manager";
  version = "0.1.0-unstable-2026-10-25";
  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "clipboard-manager";
    rev = "27a246fab0c3051a89f67e137dddada1869145ca";
    hash = "sha256-SsP4DxaJtzfvQkGWQ+fZcIgUngyP94LRh+ymffowNHw=";
  };
  cargoHash = "sha256-ABo4fAtFCaIyNukOUZqHpBhR0fANkb/h7lz755LyRpA=";
  nativeBuildInputs = [ libcosmicAppHook pkg-config ];
  buildInputs = [ openssl sqlite ];
  env.CLIPBOARD_MANAGER_COMMIT = "27a246f";
  postInstall = ''
    appid=io.github.cosmic_utils.cosmic-ext-applet-clipboard-manager
    install -Dm644 res/desktop_entry.desktop "$out/share/applications/$appid.desktop"
    install -Dm644 res/metainfo.xml "$out/share/metainfo/$appid.metainfo.xml"
    install -Dm644 res/app_icon.svg "$out/share/icons/hicolor/scalable/apps/$appid-symbolic.svg"
  '';
  meta = {
    description = "Clipboard history applet for COSMIC";
    homepage = "https://github.com/cosmic-utils/clipboard-manager";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-applet-clipboard-manager";
    platforms = lib.platforms.linux;
  };
}
