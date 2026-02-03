#!/bin/bash
# Role: 01-gui-cinnamon
# Description: Installs the Cinnamon desktop environment and X.org server.

set -euo pipefail

# --- Вспомогательные функции ---
log_info() { echo "[INFO] $*"; }
log_warn() { echo "[WARN] $*"; }
log_error() { echo "[ERROR] $*"; }

require_root() {
  if [ "$(id -u)" -ne 0 ]; then
    log_error "Скрипт должен быть запущен с правами root (sudo)."
    exit 1
  fi
}

confirm_action() {
  if [ "${AUTO_CONFIRM:-}" = "1" ]; then
    log_info "AUTO_CONFIRM=1 — подтверждение пропущено."
    return 0
  fi

  local prompt="$1"
  read -r -p "$prompt [y/N]: " reply
  case "$reply" in
    [Yy]|[Yy][Ee][Ss]) ;;
    *) log_warn "Операция отменена пользователем."; exit 1 ;;
  esac
}

require_root
confirm_action "Установить графическое окружение Cinnamon и X.org?"

log_info "ROLE: 01-gui-cinnamon"

# --- Установка GUI ---
log_info "Установка Cinnamon и X.org..."
apt-get install -y cinnamon-desktop-environment xorg

# --- Дисплей-менеджер LightDM (избегаем конфликта GDM с Cinnamon на ноутбуках) ---
log_info "Установка LightDM для сессии Cinnamon..."
apt-get install -y lightdm
# Переключаем на LightDM по умолчанию (устраняет "Oh no! Something has gone wrong" с GDM)
if command -v update-alternatives >/dev/null 2>&1; then
  update-alternatives --set x-display-manager /usr/sbin/lightdm 2>/dev/null || true
fi
log_info "LightDM установлен как дисплей-менеджер по умолчанию."

# --- PolicyKit правило для RDP ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
POLKIT_RULE_SOURCE="$SCRIPT_DIR/files/02-allow-colord.rules"
POLKIT_RULE_DEST="/etc/polkit-1/rules.d/02-allow-colord.rules"

log_info "Применение PolicyKit-правила для RDP..."
if [ -f "$POLKIT_RULE_SOURCE" ]; then
  cp "$POLKIT_RULE_SOURCE" "$POLKIT_RULE_DEST"
  log_info "PolicyKit-правило установлено: $POLKIT_RULE_DEST"
else
  log_warn "Файл правила не найден: $POLKIT_RULE_SOURCE"
fi

log_info "ROLE: 01-gui-cinnamon - COMPLETE"
