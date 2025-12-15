# Tiling Window Managers

Configuration et documentation pour Niri, un gestionnaire de fenêtres en mosaïque (tiling window manager).

## Niri

Niri est un gestionnaire de fenêtres Wayland scrollable avec un modèle de fenêtrage unique basé sur des colonnes.

**Documentation complète des raccourcis clavier :** [config/niri/README.md](config/niri/README.md)

## Structure des fichiers

```
tilling/
├── config/
│   └── niri/          # Configuration Niri
│       ├── README.md  # Raccourcis clavier Niri
│       └── ...
└── README.md          # Ce fichier
```

## Notes

- `Mod` / `SUPER` fait référence à la touche Super/Windows
- La configuration Niri est optimisée pour le layout clavier bépo
- La configuration utilise `swayosd-client` pour l'affichage OSD