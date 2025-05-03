#!/bin/bash

set -e  
# Detect OS
source /etc/os-release
dotfiles="dotfiles"
dotfileDirs=( $(ls -d */ | sed 's:/*$::'))
if [[ "$ID_LIKE" =~ (ubuntu|debian) || "$ID" =~ (ubuntu|debian) ]]; then
    os="ubuntu"
elif [[ "$ID_LIKE" =~ (arch) || "$ID" =~ (arch) ]]; then
    os="arch"
    sh_pkg="sudo pacman -S --noconfirm"
    d_pkg="yay -S --noconfirm"
else
    os="unknown"
fi

log() {
  echo
  echo "==================== $1 ===================="
  echo
}

if [[ "$os" == "arch" ]]; then
  if ! command -v yay &> /dev/null; then
    echo "❌ yay is not installed. Please install yay first!"
    exit 1
  fi
fi

packages() {
  if [[ "$os" == "ubuntu" ]]; then
    log "Starting apt package installation"

    sudo apt update && sudo apt install -y \
      lsd \
      fzf \
      plymouth \
      gnome-shell-extensions \
      gnome-browser-connector \
      wine \
      xclip \
      lua5.4 \
      luarocks \
      alacritty \
      kitty \
      stow\
      network-manager-applet

    log "Finished apt package installation"

    echo "🚫 Skipping AUR packages — only available on Arch"

  elif [[ "$os" == "arch" ]]; then
    log "Starting Pacman package installation"
    if [[ ! command -v yay > /dev/null 2>&1 ]]; then
      sudo pacman -S --needed --noconfirm git base-devel  && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
    fi
    $sh_pkg \
      gnome\
      gnome-extra\
      neovim\
      lsd \
      fzf \
      plymouth \
      plymouth-theme-arch-logo \
      gnome-shell-extension-gpaste \
      gpaste \
      gnome-browser-connector \
      gnome-shell-extension-prefs \
      gnome-shell-extension-manager \
      wine \
      xclip \
      lua \
      luarocks \
      alacritty \
      kitty \
      hyprland \
      wofi \
      waybar\
      network-manager-applet

    log "Finished Pacman package installation"

    $d_pkg \
      whatsapp-nativefier \
      hypershot \
      hyprshot \
      swaync \
      hyprlock \
      hypridle \
      stow \
      hyprpaper \
      nwg-look \
      catppuccin-gtk-theme-moca \
      catppuccin-gtk-theme-mocha \
      docker-git \

    log "Finished AUR (yay) package installation"
  else
    echo "❌ Unknown or unsupported OS"
    exit 1
  fi
}

dotfilesChecker() {
  log "Setting up Dotfiles"

  if [[ "$os" == "ubuntu" ]]; then
    echo "⚠️ Some dotfiles (like Hyprland) might be Arch-specific and may not work on Ubuntu."
  fi

  if [ -d "$dotfiles" ]; then
    cd "$dotfiles"
    for dir in "${dotfileDirs[@]}"; do
      stow "$dir"
    done
  else
    echo "❌ Something went wrong. Please check if '$dotfiles' exists."
  fi
}

log "Starting package installation for $os"

packages
dotfilesChecker

echo
echo "✅ All packages installed successfully!"
echo "📦 Dotfiles setup complete. You're good to go!"

