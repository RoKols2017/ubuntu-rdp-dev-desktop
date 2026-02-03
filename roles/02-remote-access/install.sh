#!/bin/bash
# Role: 02-remote-access
# Description: Installs and configures xrdp to work with Cinnamon.

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
confirm_action "Установить и настроить RDP (xrdp) для Cinnamon?"

log_info "ROLE: 02-remote-access"

# --- Установка xrdp ---
log_info "Установка xrdp..."
apt-get install -y xrdp

log_info "Добавление пользователя xrdp в группу ssl-cert..."
adduser xrdp ssl-cert

# --- Настройка сессии ---
log_info "Настройка запуска cinnamon-session в xrdp..."
STARTWM_FILE="/etc/xrdp/startwm.sh"
if [ ! -f "$STARTWM_FILE" ]; then
  log_error "Файл не найден: $STARTWM_FILE"
  exit 1
fi

if ! grep -q "exec cinnamon-session" "$STARTWM_FILE"; then
  sed -i.bak '/^test -x \/etc\/X11\/Xsession && \/etc\/X11\/Xsession/i exec cinnamon-session' "$STARTWM_FILE"
  log_info "Добавлен запуск cinnamon-session."
else
  log_info "Запуск cinnamon-session уже настроен."
fi

# --- Служба xrdp ---
log_info "Включение и перезапуск службы xrdp..."
systemctl enable xrdp
systemctl restart xrdp

log_info "ROLE: 02-remote-access - COMPLETE"
