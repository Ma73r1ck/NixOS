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
