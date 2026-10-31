# NixOS config

## Apply locally (flake)
```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Apply from GitHub (flake)
```bash
sudo nixos-rebuild switch --flake github:Ma73r1ck/NixOS#nixos
```

## Apply without flakes (legacy)
```bash
sudo nixos-rebuild switch
```

## Layout
- configs/nixos/configuration.nix
- configs/nixos/hardware-configuration.nix
- modules/
- overlays/

## COSMIC 1.11 on NixOS 26.05

The system stays pinned to NixOS 26.05. A separate, pinned nixpkgs input supplies COSMIC 1.11.0 packages and their dependencies. The desktop module is backported from that same input, omitting `security.polkit.enablePkexecWrapper`, which does not exist in 26.05. Version assertions guard the session, compositor, panel, and settings packages.

Build before activating:
```bash
nix build .#nixosConfigurations.nixos.config.system.build.toplevel
```

After activation, select COSMIC in SDDM. Plasma remains available. To remove the backport, remove `./modules/cosmic-1.11.nix` from the flake modules, remove the `cosmic-source` input and its special argument, then update the lock file.
