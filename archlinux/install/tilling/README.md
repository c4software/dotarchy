# Tiling Window Managers

Configuration et documentation pour les gestionnaires de fenêtres en mosaïque (tiling window managers).

## Gestionnaires disponibles

### Niri

Niri est un gestionnaire de fenêtres Wayland scrollable avec un modèle de fenêtrage unique basé sur des colonnes.

**Documentation complète des raccourcis clavier :** [config/niri/README.md](config/niri/README.md)

### Hyprland

Hyprland est un compositeur Wayland dynamique avec des animations fluides et une configuration flexible.

**Documentation complète des raccourcis clavier :** [config/hypr/README.md](config/hypr/README.md)

## Structure des fichiers

```
tilling/
├── config/
│   ├── hypr/          # Configuration Hyprland
│   │   ├── README.md  # Raccourcis clavier Hyprland
│   │   └── ...
│   └── niri/          # Configuration Niri
│       ├── README.md  # Raccourcis clavier Niri
│       └── ...
└── README.md          # Ce fichier
```

## Notes

- Les deux gestionnaires utilisent des raccourcis similaires pour faciliter la transition
- `Mod` / `SUPER` fait référence à la touche Super/Windows
- La configuration Niri est optimisée pour le layout clavier bépo
- Les deux configurations utilisent `swayosd-client` pour l'affichage OSD