#!/bin/bash
# =============================================================================
# Hyprland Deploy Script - Vic's Dotfiles
# Copia todos los configs a sus ubicaciones correctas
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

DOTFILES_DIR="$(cd "$(dirname "$0")/dotfiles" && pwd)"

echo ""
echo "============================================="
echo "   Hyprland Deploy - Vic's Dotfiles"
echo "   Origen: $DOTFILES_DIR"
echo "============================================="
echo ""

# ── Verificar que no se corra como root ─────────────────
if [ "$EUID" -eq 0 ]; then
    error "No corras este script como root."
fi

# ── Función para hacer backup y copiar ──────────────────
deploy() {
    local src="$1"
    local dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        warn "Backup: $dst → $dst.bak"
        cp -r "$dst" "$dst.bak"
    fi
    mkdir -p "$(dirname "$dst")"
    cp -r "$src" "$dst"
    success "Copiado: $dst"
}

# =============================================================================
# 1. HYPRLAND
# =============================================================================
info "Desplegando configs de Hyprland..."

deploy "$DOTFILES_DIR/hypr/hyprland.conf"  ~/.config/hypr/hyprland.conf
deploy "$DOTFILES_DIR/hypr/monitors.conf"  ~/.config/hypr/monitors.conf
deploy "$DOTFILES_DIR/hypr/workspaces.conf" ~/.config/hypr/workspaces.conf
deploy "$DOTFILES_DIR/hypr/hypridle.conf"  ~/.config/hypr/hypridle.conf
deploy "$DOTFILES_DIR/hypr/hyprlock.conf"  ~/.config/hypr/hyprlock.conf
deploy "$DOTFILES_DIR/hypr/wallpaper.sh"   ~/.config/hypr/wallpaper.sh
deploy "$DOTFILES_DIR/hypr/hotcorner.sh"   ~/.config/hypr/hotcorner.sh
deploy "$DOTFILES_DIR/hypr/modules"        ~/.config/hypr/modules
deploy "$DOTFILES_DIR/hypr/scripts"        ~/.config/hypr/scripts

chmod +x ~/.config/hypr/wallpaper.sh
chmod +x ~/.config/hypr/hotcorner.sh
chmod +x ~/.config/hypr/scripts/gtk.sh
chmod +x ~/.config/hypr/scripts/bar-switch.sh
chmod +x ~/.config/hypr/scripts/install-updates.sh

# Fallback: evita error "globbing: found no match" si aún no se ha aplicado ningún tema
if [ ! -f ~/.config/hypr/generated-theme.conf ]; then
    touch ~/.config/hypr/generated-theme.conf
    info "generated-theme.conf creado vacío — corre apply-theme.sh para aplicar un tema"
fi

# =============================================================================
# 2. WAYBAR
# =============================================================================
info "Desplegando Waybar..."

deploy "$DOTFILES_DIR/waybar/config"    ~/.config/waybar/config
deploy "$DOTFILES_DIR/waybar/style.css" ~/.config/waybar/style.css
if [ -d "$DOTFILES_DIR/waybar/scripts" ]; then
    deploy "$DOTFILES_DIR/waybar/scripts" ~/.config/waybar/scripts
    chmod +x ~/.config/waybar/scripts/* 2>/dev/null || true
fi

# =============================================================================
# 3. ROFI
# =============================================================================
info "Desplegando Rofi..."

deploy "$DOTFILES_DIR/rofi/config.rasi"    ~/.config/rofi/config.rasi
deploy "$DOTFILES_DIR/rofi/spotlight.rasi" ~/.config/rofi/spotlight.rasi
deploy "$DOTFILES_DIR/rofi/launchpad.rasi" ~/.config/rofi/launchpad.rasi
deploy "$DOTFILES_DIR/rofi/symphony"       ~/.config/rofi/symphony

# =============================================================================
# 4. KITTY (terminal)
# =============================================================================
info "Desplegando Kitty..."

deploy "$DOTFILES_DIR/kitty/kitty.conf"              ~/.config/kitty/kitty.conf
deploy "$DOTFILES_DIR/kitty/kitty-cursor-trail.conf" ~/.config/kitty/kitty-cursor-trail.conf
deploy "$DOTFILES_DIR/kitty/grag-path.sh"            ~/.config/kitty/grag-path.sh
deploy "$DOTFILES_DIR/kitty/themes"                  ~/.config/kitty/themes
chmod +x ~/.config/kitty/grag-path.sh

# =============================================================================
# 5. FISH (shell)
# =============================================================================
info "Desplegando Fish..."

deploy "$DOTFILES_DIR/fish/config.fish"              ~/.config/fish/config.fish
deploy "$DOTFILES_DIR/fish/conf.d/00_init.fish"      ~/.config/fish/conf.d/00_init.fish
deploy "$DOTFILES_DIR/fish/conf.d/10-aliases.fish"   ~/.config/fish/conf.d/10-aliases.fish
deploy "$DOTFILES_DIR/fish/conf.d/20-customization.fish" ~/.config/fish/conf.d/20-customization.fish
deploy "$DOTFILES_DIR/fish/conf.d/30-autostart.fish" ~/.config/fish/conf.d/30-autostart.fish

# =============================================================================
# 6. OH-MY-POSH (prompt)
# =============================================================================
info "Desplegando Oh-My-Posh..."

deploy "$DOTFILES_DIR/ohmyposh/zen.toml"                    ~/.config/ohmyposh/zen.toml
deploy "$DOTFILES_DIR/ohmyposh/EDM115-newline.omp.json"     ~/.config/ohmyposh/EDM115-newline.omp.json
deploy "$DOTFILES_DIR/ohmyposh/cloud-native-azure.omp.json" ~/.config/ohmyposh/cloud-native-azure.omp.json
deploy "$DOTFILES_DIR/ohmyposh/colors.json"                 ~/.config/ohmyposh/colors.json

# =============================================================================
# 7. FASTFETCH
# =============================================================================
info "Desplegando Fastfetch..."

deploy "$DOTFILES_DIR/fastfetch/config.jsonc" ~/.config/fastfetch/config.jsonc
deploy "$DOTFILES_DIR/fastfetch/25.jsonc"     ~/.config/fastfetch/25.jsonc

# =============================================================================
# 8. MAKO (notificaciones)
# =============================================================================
info "Desplegando Mako..."

deploy "$DOTFILES_DIR/mako/config" ~/.config/mako/config

# =============================================================================
# SWAYNC (notificaciones)
# =============================================================================
info "Desplegando swaync..."

deploy "$DOTFILES_DIR/swaync/config.json" ~/.config/swaync/config.json
deploy "$DOTFILES_DIR/swaync/style.css"   ~/.config/swaync/style.css

# =============================================================================
# FONTCONFIG
# =============================================================================
info "Desplegando fontconfig..."

deploy "$DOTFILES_DIR/fontconfig/fonts.conf" ~/.config/fontconfig/fonts.conf

# =============================================================================
# 5. EWW (widgets)
# =============================================================================
info "Desplegando eww..."

deploy "$DOTFILES_DIR/eww/eww.yuck"                    ~/.config/eww/eww.yuck
deploy "$DOTFILES_DIR/eww/eww.css"                     ~/.config/eww/eww.css
deploy "$DOTFILES_DIR/eww/scripts/fetch"               ~/.config/eww/scripts/fetch
deploy "$DOTFILES_DIR/eww/scripts/fastfetch_info.py"   ~/.config/eww/scripts/fastfetch_info.py
chmod +x ~/.config/eww/scripts/fetch
chmod +x ~/.config/eww/scripts/fastfetch_info.py

# =============================================================================
# 6. WLOGOUT (power menu)
# =============================================================================
info "Desplegando wlogout..."

deploy "$DOTFILES_DIR/wlogout/layout"    ~/.config/wlogout/layout
deploy "$DOTFILES_DIR/wlogout/style.css" ~/.config/wlogout/style.css
deploy "$DOTFILES_DIR/wlogout/icons"     ~/.config/wlogout/icons

# =============================================================================
# 7. XDG PORTALS
# =============================================================================
info "Desplegando xdg-desktop-portal..."

deploy "$DOTFILES_DIR/xdg-desktop-portal/hyprland-portals.conf" \
       ~/.config/xdg-desktop-portal/hyprland-portals.conf

# =============================================================================
# 8. GTK4
# =============================================================================
info "Configurando GTK4..."

deploy "$DOTFILES_DIR/gtk-4.0/settings.ini" ~/.config/gtk-4.0/settings.ini
success "GTK4 configurado"

# =============================================================================
# 9. QT6CT
# =============================================================================
info "Desplegando qt6ct..."

deploy "$DOTFILES_DIR/qt6ct/qt6ct.conf" ~/.config/qt6ct/qt6ct.conf

# =============================================================================
# 10. KDE (kdeglobals + integración Qt)
# =============================================================================
info "Desplegando kdeglobals..."

deploy "$DOTFILES_DIR/kdeglobals" ~/.config/kdeglobals

# Reconstruir cache de KDE
if command -v kbuildsycoca6 &>/dev/null; then
    kbuildsycoca6 --noincremental &>/dev/null &
    success "KDE sycoca rebuild iniciado"
fi

# Fix para Open With en Dolphin
if [ ! -f /etc/xdg/menus/applications.menu ]; then
    info "Aplicando fix de Dolphin 'Abrir con' (requiere sudo)..."
    sudo ln -s /etc/xdg/menus/plasma-applications.menu /etc/xdg/menus/applications.menu \
        && success "Fix Dolphin aplicado" \
        || warn "No se pudo crear el symlink. Hazlo manual: sudo ln -s /etc/xdg/menus/plasma-applications.menu /etc/xdg/menus/applications.menu"
else
    success "Fix Dolphin ya aplicado"
fi

# =============================================================================
# 11. ARCH-UPDATE
# =============================================================================
info "Desplegando arch-update..."

deploy "$DOTFILES_DIR/arch-update/arch-update.conf" ~/.config/arch-update/arch-update.conf
deploy "$DOTFILES_DIR/applications/arch-update.desktop" ~/.local/share/applications/arch-update.desktop
update-desktop-database ~/.local/share/applications/ &>/dev/null

# =============================================================================
# 12. HYPRSWITCH
# =============================================================================
info "Desplegando hyprswitch..."

deploy "$DOTFILES_DIR/hyprswitch/style.css" ~/.config/hyprswitch/style.css
deploy "$DOTFILES_DIR/hyprswitch/launch.sh" ~/.config/hyprswitch/launch.sh
chmod +x ~/.config/hyprswitch/launch.sh

# =============================================================================
# 13. THEME-SWITCHER
# =============================================================================
info "Desplegando theme-switcher..."

mkdir -p ~/.config/theme-switcher/themes
mkdir -p ~/.local/bin

deploy "$DOTFILES_DIR/theme-switcher/apply-theme.sh" ~/.config/theme-switcher/apply-theme.sh
deploy "$DOTFILES_DIR/theme-switcher/thumb-gen.sh"  ~/.config/theme-switcher/thumb-gen.sh
chmod +x ~/.config/theme-switcher/apply-theme.sh
chmod +x ~/.config/theme-switcher/thumb-gen.sh

deploy "$DOTFILES_DIR/theme-switcher/templates" ~/.config/theme-switcher/templates
mkdir -p ~/.config/theme-switcher/templates/rofi
deploy "$DOTFILES_DIR/theme-switcher/templates/rofi/spotlight.rasi.tpl"  ~/.config/theme-switcher/templates/rofi/spotlight.rasi.tpl
deploy "$DOTFILES_DIR/theme-switcher/templates/rofi/launchpad.rasi.tpl"  ~/.config/theme-switcher/templates/rofi/launchpad.rasi.tpl
deploy "$DOTFILES_DIR/theme-switcher/templates/rofi/wallpaper-grid.rasi.tpl" ~/.config/theme-switcher/templates/rofi/wallpaper-grid.rasi.tpl
deploy "$DOTFILES_DIR/theme-switcher/templates/eww.css.tpl"              ~/.config/theme-switcher/templates/eww.css.tpl

for theme in catppuccin catppuccin-latte dracula dynamic everforest flick0-aurora github-dark-colorblind graphite kanagawa nord tokyonight yorha; do
    mkdir -p ~/.config/theme-switcher/themes/$theme/templates/waybar
    deploy "$DOTFILES_DIR/theme-switcher/themes/$theme/colors.json" \
           ~/.config/theme-switcher/themes/$theme/colors.json
    deploy "$DOTFILES_DIR/theme-switcher/themes/$theme/theme.json" \
           ~/.config/theme-switcher/themes/$theme/theme.json
    deploy "$DOTFILES_DIR/theme-switcher/themes/$theme/templates" \
           ~/.config/theme-switcher/themes/$theme/templates
done

deploy "$DOTFILES_DIR/scripts/theme-picker.sh"     ~/.local/bin/theme-picker
deploy "$DOTFILES_DIR/scripts/wallpaper-picker.sh" ~/.local/bin/wallpaper-picker
chmod +x ~/.local/bin/theme-picker ~/.local/bin/wallpaper-picker

# Sidebar/eww helper scripts
mkdir -p ~/.config/scripts
deploy "$DOTFILES_DIR/scripts/cpu"        ~/.config/scripts/cpu
deploy "$DOTFILES_DIR/scripts/disk"       ~/.config/scripts/disk
deploy "$DOTFILES_DIR/scripts/memory"     ~/.config/scripts/memory
deploy "$DOTFILES_DIR/scripts/tempe"      ~/.config/scripts/tempe
deploy "$DOTFILES_DIR/scripts/display.sh" ~/.config/scripts/display.sh
deploy "$DOTFILES_DIR/scripts/uptime.sh"  ~/.config/scripts/uptime.sh
deploy "$DOTFILES_DIR/scripts/updates.sh" ~/.config/scripts/updates.sh
deploy "$DOTFILES_DIR/scripts/Weather.sh" ~/.config/scripts/Weather.sh
chmod +x ~/.config/scripts/cpu ~/.config/scripts/disk ~/.config/scripts/memory \
         ~/.config/scripts/tempe ~/.config/scripts/display.sh \
         ~/.config/scripts/uptime.sh ~/.config/scripts/updates.sh \
         ~/.config/scripts/Weather.sh

# Matugen (tema dinámico) — copiar config de ejemplo si no existe
if [ ! -f ~/.config/matugen/config.toml ]; then
    info "Copiando config de matugen (tema dinámico)..."
    mkdir -p ~/.config/matugen/templates
    cp "$DOTFILES_DIR/matugen/config.toml"              ~/.config/matugen/config.toml
    cp "$DOTFILES_DIR/matugen/templates/colors.json.tpl" ~/.config/matugen/templates/colors.json.tpl
    success "Matugen config copiado"
fi

warn "NOTA: Los wallpapers no están en dotfiles."
warn "Cópialos manualmente desde /home/vhs/tmp/theme-switcher/ a ~/.config/theme-switcher/themes/"

# =============================================================================
# 14. MIMEAPPS (apps por defecto)
# =============================================================================
info "Configurando apps por defecto..."

cat > ~/.config/mimeapps.list << 'EOF'
[Default Applications]
image/jpeg=org.gnome.eog.desktop
image/png=org.gnome.eog.desktop
image/gif=org.gnome.eog.desktop
image/webp=org.gnome.eog.desktop
image/bmp=org.gnome.eog.desktop
image/tiff=org.gnome.eog.desktop
image/avif=org.gnome.eog.desktop
image/heif=org.gnome.eog.desktop
video/mp4=vlc.desktop
video/mpeg=vlc.desktop
video/x-matroska=vlc.desktop
video/webm=vlc.desktop
video/x-msvideo=vlc.desktop
video/x-flv=vlc.desktop
video/3gpp=vlc.desktop
audio/mpeg=vlc.desktop
audio/ogg=vlc.desktop
audio/flac=vlc.desktop
audio/x-wav=vlc.desktop
text/plain=org.kde.kate.desktop
text/x-python=code.desktop
text/x-csrc=code.desktop
application/json=code.desktop
application/javascript=code.desktop
application/x-shellscript=code.desktop
application/pdf=org.gnome.Evince.desktop
inode/directory=org.kde.dolphin.desktop
text/html=firefox.desktop
x-scheme-handler/http=firefox.desktop
x-scheme-handler/https=firefox.desktop
EOF

success "MIME apps configuradas"

# =============================================================================
# 13. DIRECTORIOS EXTRA
# =============================================================================
mkdir -p ~/Imágenes
success "Directorio ~/Imágenes creado"

# =============================================================================
# RESUMEN
# =============================================================================
echo ""
echo "============================================="
echo "   Deploy completo."
echo ""
echo "   PASOS FINALES MANUALES:"
echo "   1. Abre kvantummanager → selecciona tema Kvantum"
echo "   2. Verifica íconos: Slot-Beauty-Dark-Icons"
echo "      cursor: catppuccin-mocha-dark"
echo "   3. Fix Dolphin Open With (una vez, con sudo):"
echo "      sudo ln -s /etc/xdg/menus/plasma-applications.menu \\"
echo "                 /etc/xdg/menus/applications.menu"
echo "   4. Instala plasma-integration para fuentes KDE:"
echo "      sudo pacman -S plasma-integration"
echo "   5. Primera vez: corre 'hyprctl monitors' para verificar"
echo "      nombres de monitores (DP-1 y HDMI-A-1)"
echo "   6. Para hyprswitch: instalar desde AUR con yay -S hyprswitch"
echo "   7. Tema Dynamic: copia wallpapers a ~/.config/theme-switcher/themes/[tema]/wallpapers/"
echo "      Luego activa con: apply-theme.sh dynamic"
echo "============================================="
echo ""
