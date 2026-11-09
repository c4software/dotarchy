-- Affiche les fichiers cachés (.env, .gitignore, …) par défaut dans Neo-tree
return {
  "nvim-neo-tree/neo-tree.nvim",
  optional = true, -- ne s'applique que si l'extra editor.neo-tree est activé
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
      },
    },
  },
}
