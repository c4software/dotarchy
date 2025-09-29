function setup() {
  # Installation de YAY
  if ! command -v yay &>/dev/null; then
      echo -e "Installing Yay (AUR helper)"
      sudo pacman -S --needed git base-devel --noconfirm
      git clone https://aur.archlinux.org/yay.git /tmp/yay
      cd /tmp/yay
      makepkg -si --noconfirm
      cd -
      rm -rf /tmp/yay
  fi

  echo "First, we update package list and system"
  sudo pacman -Syu

  # Install gum for menus
  if ! command -v gum &>/dev/null; then
      echo -e "Installing gum (for menus)"
      sudo pacman -S --noconfirm gum
  fi
}

function check(){
  # Check if yay is installed
  if ! command -v yay &>/dev/null; then
      show_warning "Yay (AUR helper)" "yay is not installed. Please install it to manage AUR packages. You can run the init script again to install it."
  else
      show_success "Yay (AUR helper) is installed"
  fi

  # Check if gum is installed
  if ! command -v gum &>/dev/null; then
      show_warning "Gum (for menus)" "gum is not installed. Please install it"
  else
      show_success "Gum (for menus) is installed"
  fi
}