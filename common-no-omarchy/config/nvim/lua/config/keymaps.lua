-- Keymaps are automatically loaded on the VeryLazy event
--
-- Cœur des raccourcis VS Code, par-dessus les defaults LazyVim.
-- Chargé après LazyVim : tout ce qui est ici gagne.
--
-- Prérequis : `stty -ixon` dans le shell (sinon <C-s>/<C-q> sont mangés par le TTY)
-- et un terminal avec le Kitty keyboard protocol pour <C-S-x> et <C-.>.
-- Bépo : on évite <C-\>, <C-`>, <C-]> (touches AltGr). <C-/> passe bien.
--
-- Les raccourcis suivants sont déjà fournis par LazyVim et ne sont pas redéfinis :
--   <C-s> enregistrer, <Esc> effacer la surbrillance, <C-h/j/k/l> fenêtres.

local map = vim.keymap.set

-- Aller-retour dans l'historique de navigation (définitions, références, etc.)
vim.keymap.set("n", "gb", "<C-o>", { desc = "Go back (previous location)" })

-- LazyVim met le terminal sur <C-/> : on libère la touche pour "commenter".
pcall(vim.keymap.del, "t", "<C-/>")

-- Fichier / buffer
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "Nouveau fichier" })
map("n", "<C-w>", "<leader>bd", { remap = true, desc = "Fermer le buffer" })
map("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Buffer suivant" })
map("n", "<C-S-Tab>", "<cmd>bprevious<cr>", { desc = "Buffer précédent" })

-- Édition
map("n", "<C-a>", "ggVG", { desc = "Tout sélectionner" })
map({ "i", "v" }, "<C-a>", "<esc>ggVG", { desc = "Tout sélectionner" })
map("n", "<C-z>", "u", { desc = "Annuler" })
map("i", "<C-z>", "<C-o>u", { desc = "Annuler" })
map("n", "<C-y>", "<C-r>", { desc = "Rétablir" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Rétablir" })

-- Presse-papier système (le Visual Block reste natif sur <C-q>)
map("v", "<C-c>", '"+y', { desc = "Copier" })
map("n", "<C-c>", '"+yy', { desc = "Copier la ligne" })
map("v", "<C-x>", '"+d', { desc = "Couper" })
map("n", "<C-x>", '"+dd', { desc = "Couper la ligne" })
map("n", "<C-v>", '"+p', { desc = "Coller" })
map("i", "<C-v>", "<C-r><C-o>+", { desc = "Coller" })
map("v", "<C-v>", '"_d"+P', { desc = "Coller par-dessus" })
map("c", "<C-v>", "<C-r>+", { desc = "Coller" })

-- Déplacer des lignes (Alt+flèches est pris par Hyprland → Ctrl+Shift)
map("n", "<C-S-Down>", "<cmd>m .+1<cr>==", { desc = "Descendre la ligne" })
map("n", "<C-S-Up>", "<cmd>m .-2<cr>==", { desc = "Monter la ligne" })
map("v", "<C-S-Down>", ":m '>+1<cr>gv=gv", { desc = "Descendre la sélection" })
map("v", "<C-S-Up>", ":m '<-2<cr>gv=gv", { desc = "Monter la sélection" })

-- Indentation (garde la sélection) et commentaire
map("v", "<Tab>", ">gv", { desc = "Indenter" })
map("v", "<S-Tab>", "<gv", { desc = "Désindenter" })
map("n", "<C-/>", "gcc", { remap = true, desc = "Commenter" })
map("v", "<C-/>", "gc", { remap = true, desc = "Commenter" })

-- Recherche / navigation
map("n", "<C-f>", "/", { desc = "Rechercher dans le fichier" })
map("n", "<C-p>", "<leader>ff", { remap = true, desc = "Ouvrir un fichier" })
map("n", "<C-S-f>", "<leader>sg", { remap = true, desc = "Rechercher dans le projet" })
map("n", "<C-S-h>", "<leader>sr", { remap = true, desc = "Remplacer dans le projet" })
map("n", "<C-S-p>", "<leader>sC", { remap = true, desc = "Palette de commandes" })
map("n", "<C-S-o>", "<leader>ss", { remap = true, desc = "Aller au symbole" })

-- LSP
map("n", "<F12>", "gd", { remap = true, desc = "Aller à la définition" })
map("n", "<S-F12>", "gr", { remap = true, desc = "Références" })
map("n", "<F2>", "<leader>cr", { remap = true, desc = "Renommer le symbole" })
map("n", "<C-.>", "<leader>ca", { remap = true, desc = "Actions rapides" })
map("n", "<F8>", "]d", { remap = true, desc = "Problème suivant" })
map("n", "<S-F8>", "[d", { remap = true, desc = "Problème précédent" })
map("n", "<C-S-m>", "<leader>xx", { remap = true, desc = "Liste des problèmes" })

-- Panneaux
map("n", "<C-b>", "<leader>e", { remap = true, desc = "Explorateur" })
map("n", "<C-S-g>", "<leader>gg", { remap = true, desc = "Git (lazygit)" })
map("n", "<C-S-t>", "<leader>ft", { remap = true, desc = "Terminal" })
