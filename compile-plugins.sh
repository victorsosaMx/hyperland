#!/bin/bash
# =============================================================================
# Hyprland Plugins - Compile & Enable
# Compila e instala hyprexpo y hyprfocus via hyprpm
# Ejecutar después de instalar Hyprland o tras actualizarlo
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

echo ""
echo "============================================="
echo "   Hyprland Plugins - Vic's Dotfiles"
echo "============================================="
echo ""

# ── Verificar que no se corra como root ─────────────────
if [ "$EUID" -eq 0 ]; then
    error "No corras este script como root."
fi

# ── Verificar que Hyprland esté instalado ────────────────
if ! command -v hyprpm &>/dev/null; then
    error "hyprpm no encontrado. Instala hyprland primero."
fi

# ── Crear directorio de plugins ──────────────────────────
mkdir -p ~/.config/hypr/plugins

# ── Actualizar hyprpm ────────────────────────────────────
info "Actualizando hyprpm..."
hyprpm update
success "hyprpm actualizado"

# ── Agregar hyprland-plugins si no está registrado ───────
info "Registrando hyprland-plugins..."
hyprpm add https://github.com/hyprwm/hyprland-plugins || warn "Ya registrado, continuando..."

# ── Compilar y habilitar hyprexpo ────────────────────────
info "Compilando hyprexpo..."
hyprpm enable hyprexpo
success "hyprexpo habilitado"

# ── Compilar y habilitar hyprfocus ───────────────────────
info "Compilando hyprfocus..."
hyprpm enable hyprfocus
success "hyprfocus habilitado"

# ── Recargar plugins en sesión activa (si hay una) ───────
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    info "Recargando plugins en sesión activa..."
    hyprpm reload -n
    success "Plugins recargados"
else
    warn "No hay sesión Hyprland activa — los plugins cargarán al iniciar sesión"
fi

echo ""
echo "============================================="
echo "   Plugins compilados correctamente."
echo "   hyprexpo  — Super+Tab (grid de workspaces)"
echo "   hyprfocus — animación al cambiar foco"
echo ""
echo "   Si Hyprland se actualiza, vuelve a correr:"
echo "   bash compile-plugins.sh"
echo "============================================="
echo ""
