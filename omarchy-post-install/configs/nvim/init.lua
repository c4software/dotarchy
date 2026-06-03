-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.keymap.set("n", "gb", "<C-o>", { desc = "Go back (previous location)" })
