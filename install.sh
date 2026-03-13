#!/bin/bash
# =============================================================================
# Hyprland Install Script - Vic's Setup
# =============================================================================
# GPU: AMD RX 6600 | Monitores: 2560x1440 (DP-1) + 1920x1080 (HDMI-A-1)
# Distro: Arch Linux | WM: Hyprland
# =============================================================================

set -e  # salir si cualquier comando falla

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

echo ""
echo "============================================="
echo "   Hyprland Setup - Vic's Dotfiles"
echo "============================================="
echo ""

# ── Verificar que no se corra como root ─────────────────
if [ "$EUID" -eq 0 ]; then
    error "No corras este script como root."
fi

# ── Verificar yay ────────────────────────────────────────
if ! command -v yay &>/dev/null; then
    error "yay no está instalado. Instálalo primero: https://github.com/Jguer/yay"
fi

# =============================================================================
# 1. PAQUETES OFICIALES
# =============================================================================
info "Instalando paquetes desde repositorios oficiales..."

PACMAN_PKGS=(
    # Hyprland core
    hyprland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # Barra
    waybar

    # Wallpaper
    swww

    # Launcher
    rofi-wayland

    # Notificaciones
    mako

    # Lockscreen + idle
    hyprlock
    hypridle

    # Clipboard
    wl-clipboard
    cliphist

    # Screenshots
    grim
    slurp

    # Audio
    pamixer
    playerctl
    pavucontrol
    pipewire
    pipewire-pulse
    pipewire-alsa
    wireplumber

    # Brillo
    brightnessctl

    # Terminal
    kitty

    # File manager
    dolphin

    # GTK theme tool
    nwg-look

    # Íconos
    papirus-icon-theme

    # Fuentes
    ttf-jetbrains-mono-nerd
    ttf-font-awesome

    # Power menu
    #wlogout

    # MIME handler
    handlr-regex

    # Wayland utils
    qt5-wayland
    qt6-wayland
    polkit-kde-agent

    # Thumbnails para theme/wallpaper picker
    imagemagick

    # Build deps para hyprpm
    cmake
    cpio
    pkgconf
    git
    gcc

    # Kvantum (temas Qt)
    kvantum

    # Integración Qt con Hyprland (fuentes, íconos, theming)
    plasma-integration
    kde-cli-tools
)

sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
success "Paquetes oficiales instalados"

# =============================================================================
# 2. PAQUETES AUR
# =============================================================================
info "Instalando paquetes desde AUR..."

AUR_PKGS=(
    # Widgets
    eww

    # Fuentes
    ttf-orbitron

    # Temas Catppuccin
    catppuccin-gtk-theme-mocha
    kvantum-theme-catppuccin-git
    catppuccin-cursors-mocha

    # Wallpaper manager GUI
    waypaper

    # Notificaciones (SwayNC)
    swaync

    # Tema dinámico desde wallpaper (opcional, requerido para el tema 'dynamic')
    matugen
)

yay -S --needed --noconfirm "${AUR_PKGS[@]}"
success "Paquetes AUR instalados"

# =============================================================================
# 3. HYPRPM PLUGINS
# =============================================================================
info "Instalando plugins de Hyprland (hyprexpo)..."

hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo

success "hyprexpo instalado y habilitado"

# =============================================================================
# 4. DIRECTORIOS NECESARIOS
# =============================================================================
info "Creando directorios necesarios..."

mkdir -p ~/Imágenes
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/mako
mkdir -p ~/.config/eww
mkdir -p ~/.config/wlogout
mkdir -p ~/.config/xdg-desktop-portal
mkdir -p ~/.config/gtk-4.0

success "Directorios creados"

echo ""
echo "============================================="
echo "   Instalación completa."
echo "   Corre ./deploy.sh para aplicar los configs"
echo "============================================="
echo ""
