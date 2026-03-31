SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function setup() {
  # Install Neovim + LazyVim (https://lazyvim.org/)
  echo -e "Configuring Neovim + LazyVim"
  rm -rf ~/.config/nvim
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  cp -R "$SCRIPT_DIR/../config/nvim/"* ~/.config/nvim/
  rm -rf ~/.config/nvim/.git
  echo "vim.opt.relativenumber = false" >>~/.config/nvim/lua/config/options.lua

  # Ajout des keymaps dans ~/.config/nvim/lua/config/keymaps.lua
  # vim.keymap.set("n", "gb", "<C-^>", { desc = "Go to previous buffer" })
  echo 'vim.keymap.set("n", "gb", "<C-^>", { desc = "Go to previous buffer" })' >>~/.config/nvim/lua/config/keymaps.lua

  # Install neovim luarocks tree-sitter-cli using the package manager of the system
  if command -v apt &>/dev/null; then
    sudo apt-get update
    sudo apt-get install -y neovim luarocks tree-sitter-cli
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm --needed neovim luarocks tree-sitter-cli
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y neovim luarocks tree-sitter-cli
  elif command -v brew &>/dev/null; then
    brew install neovim luarocks tree-sitter-cli
  else
    echo "Package manager not found. Please install neovim, luarocks and tree-sitter-cli manually." >&2
    exit 1
  fi
}

function check() {
  if command -v nvim &>/dev/null; then
    show_success "Neovim"
  else
    show_error "Neovim" "Neovim is not installed."
  fi

  if [ -d ~/.config/nvim ]; then
    show_success "LazyVim"
  else
    show_error "LazyVim" "LazyVim configuration is not set up."
  fi
}
