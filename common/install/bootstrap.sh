#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function setup() {

  # Prompt the user if he wants to do the common setup, if not exit the script
  if ! gum confirm "Do you want to do the common setup?"; then
    echo "Common setup skipped. Exiting."
    exit 0
  fi

  echo -e "Move configuration files..."

  # Install rsync if not present
  if ! command -v rsync &>/dev/null; then
    if command -v apt &>/dev/null; then
      sudo apt-get update
      sudo apt-get install -y rsync
    elif command -v pacman &>/dev/null; then
      sudo pacman -Sy --noconfirm rsync
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y rsync
    else
      echo "Package manager not found. Please install rsync manually." >&2
      exit 1
    fi
  fi

  # If .config/theme (folder or symlink) exists, exclude it from being overwritten
  if [ -d ~/.config/theme ] || [ -L ~/.config/theme ]; then
    rsync -av --exclude='theme' "$SCRIPT_DIR/../config/" ~/.config/
  else
    rsync -av "$SCRIPT_DIR/../config/" ~/.config/
  fi

  # Ensure local bin exists
  mkdir -p ~/.local/bin

  # Ensure application directory exists for update-desktop-database
  mkdir -p ~/.local/share/applications

  # Install the default .profile
  cp "$SCRIPT_DIR/../default/profile" ~/.profile

  # Install Bash configuration
  cp "$SCRIPT_DIR/../default/bashrc" ~/.bashrc

  # Install Zsh configuration
  cp "$SCRIPT_DIR/../default/zshrc" ~/.zshrc

  # If gum is available, ask the user to choose between bash and zsh as default shell
  if command -v gum &>/dev/null; then
    shell_choice=$(gum choose "bash" "zsh" "skip" --header "Choose your default shell:")

    case $shell_choice in
    bash)
      chsh -s "$(which bash)"
      ;;
    zsh)
      # If pacman is available, install zsh and zsh-completions
      if command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm zsh zsh-completions
      fi
      chsh -s "$(which zsh)"
      ;;
    skip)
      echo "No shell selected. Keeping current shell ($SHELL)."
      ;;
    esac
  fi

  # Install try command
  curl -sL https://raw.githubusercontent.com/c4software/try.sh/main/try.sh -o ~/.local/bin/try
  chmod +x ~/.local/bin/try

  # Installation proj command
  curl -sL https://raw.githubusercontent.com/c4software/prj.sh/main/prj.sh -o ~/.local/bin/proj
  chmod +x ~/.local/bin/proj

  # If not MacOS, install the Bépo Dev keyboard layout
  if [[ "$OSTYPE" != "darwin"* ]]; then
    # Installation du layout de clavier Bépo Dev
    echo "Installing Bépo Dev keyboard layout (Système)..."

    if [ -d /usr/share/X11/xkb/symbols/ ]; then
      sudo wget -nc https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/bepoDev -O /usr/share/X11/xkb/symbols/bepoDev || true
      sudo cp /usr/share/X11/xkb/symbols/bepoDev /usr/share/X11/xkb/symbols/custom
      return
    fi

    # Installation bepoDev pour l'utilisateur
    echo "Installing Bépo Dev keyboard layout (Utilisateur)..."
    mkdir -p ~/.config/xkb/symbols ~/.config/xkb/rules || true
    wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/bepoDev -O ~/.config/xkb/symbols/bepoDev || true
    wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/evdev.lst -O ~/.config/xkb/rules/evdev.lst || true
    wget https://raw.githubusercontent.com/c4software/bepo_developpeur/master/linux/evdev.xml -O ~/.config/xkb/rules/evdev.xml || true
    [ -L ~/.config/xkb/rules/base.lst ] || ln -s ~/.config/xkb/rules/evdev.lst ~/.config/xkb/rules/base.lst || true
    [ -L ~/.config/xkb/rules/base.xml ] || ln -s ~/.config/xkb/rules/evdev.xml ~/.config/xkb/rules/base.xml || true
  fi
}

function check() {
  # Check if rsync is installed
  if command -v rsync &>/dev/null; then
    show_success "rsync"
  else
    show_error "rsync" "rsync is not installed."
  fi

  # Check if ./config contains the same directories as ~/.config (excluding theme)
  local all_matched=true
  for dir in "$SCRIPT_DIR/../config/"*; do
    local dirname
    dirname=$(basename "$dir")
    if [ "$dirname" != "theme" ] && [ ! -e "$HOME/.config/$dirname" ]; then
      show_error "Configuration" "$dirname is not installed in ~/.config/"
      all_matched=false
    fi
  done
  if $all_matched; then
    show_success "Configuration"
  fi
}

