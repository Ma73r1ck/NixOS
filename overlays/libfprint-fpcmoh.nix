self: super: {
  libfprint-fpcmoh = super.stdenv.mkDerivation rec {
    pname = "libfprint-fpcmoh";
    version = "1.94.9";

    # PKGBUILD pulls from GitLab tag v${version}
    src = super.fetchFromGitLab {
      owner = "libfprint";
      repo  = "libfprint";
      domain = "gitlab.freedesktop.org";
      rev   = "v${version}";
      sha256 = "sha256-UiUdZokgi27LlyO419dd+NIcQD2RSUfdsC08sW3qzko=";
    };

    fpcDriver = super.fetchurl {
      url = "https://download.lenovo.com/pccbbs/mobiles/r1slm01w.zip";
      sha256 = "c7290f2a70d48f7bdd09bee985534d3511ec00d091887b07f81cf1e08f74c145";
    };

    nativeBuildInputs = [
      super.meson
      super.ninja
      super.pkg-config
      super.gobject-introspection
      super.gtk-doc
      super.unzip
      super.patchelf
    ];

    buildInputs = [
      super.gusb
      super.pixman
      super.nss
      super.openssl
      super.systemd
      super.cairo
      super.libgudev
      super.udev
    ];

    # Apply patch manually with fuzz tolerance in postPatch
    patches = [ ];

    # даємо meson hooks правильні опції
    mesonFlags = [
      "-Dauto_features=enabled"
      "-Dwrap_mode=nodownload"
      "-Ddoc=false"
      "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
      "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
    ];

    postPatch = ''
      # Apply the fpcmoh patch with fuzz tolerance (upstream changed in 1.94.9)
      patch -p1 -F 3 < ${./396.patch} || true

      unzip ${fpcDriver} -d fpc

      # libfpcbep.so в корінь сорців
      cp -v fpc/FPC_driver_linux_*/install_fpc/libfpcbep.so ./libfpcbep.so

      # udev rule теж в корінь сорців (щоб було доступно в postInstall)
      cp -v \
        fpc/FPC_driver_linux_libfprint/install_libfprint/lib/udev/rules.d/60-libfprint-2-device-fpc.rules \
        ./60-libfprint-2-device-fpc.rules

      # змусити meson шукати fpcbep в поточній директорії
      sed -i \
        "s|find_library('fpcbep', required: true)|find_library('fpcbep', required: true, dirs: '$(pwd)')|" \
        meson.build

    '';

    postInstall = ''
      install -Dm644 ../60-libfprint-2-device-fpc.rules \
        $out/lib/udev/rules.d/60-libfprint-2-device-fpc.rules

      install -Dm755 ../libfpcbep.so $out/lib/libfpcbep.so

      needed="$(patchelf --print-needed $out/lib/libfprint-2.so | grep -i fpcbep | head -n1 || true)"
      if [ -n "$needed" ] && [ "$needed" != "libfpcbep.so" ]; then
        patchelf --replace-needed "$needed" libfpcbep.so $out/lib/libfprint-2.so
      fi
    '';


    meta = with super.lib; {
      description = "libfprint with proprietary FPC match-on-host driver (AUR-style)";
      homepage = "https://fprint.freedesktop.org/";
      license = licenses.lgpl2Plus;
      platforms = platforms.linux;
    };
  };

  # Force consumers (e.g. fprintd) to use the FPC MOH build
  libfprint = self.libfprint-fpcmoh;
}
