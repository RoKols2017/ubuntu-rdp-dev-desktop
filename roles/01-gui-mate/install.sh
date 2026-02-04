#!/bin/bash
# Role: 01-gui-mate
# Description: Installs the MATE desktop environment and X.org server.

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
confirm_action "Установить графическое окружение MATE и X.org?"

log_info "ROLE: 01-gui-mate"

# --- Установка GUI ---
log_info "Установка MATE Desktop и X.org..."
apt-get install -y ubuntu-mate-core xorg

# --- Дисплей-менеджер LightDM (рекомендуется для RDP) ---
log_info "Установка LightDM для сессии MATE..."
apt-get install -y lightdm
# Переключаем на LightDM по умолчанию (лучше работает с RDP)
if command -v update-alternatives >/dev/null 2>&1; then
  update-alternatives --set x-display-manager /usr/sbin/lightdm 2>/dev/null || true
fi
log_info "LightDM установлен как дисплей-менеджер по умолчанию."

log_info "ROLE: 01-gui-mate - COMPLETE"
