-- Affiche les fichiers cachés (.env, .gitignore, …) par défaut dans le picker Snacks
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        grep_word = { hidden = true },
      },
    },
  },
}
