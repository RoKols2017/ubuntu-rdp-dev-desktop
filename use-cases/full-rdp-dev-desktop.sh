#!/bin/bash
# Use Case: Full RDP Development Desktop
# This script orchestrates several roles to build a complete remote desktop environment.

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

# --- Пути ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROLES_DIR="$SCRIPT_DIR/../roles"

log_info "=========================================================="
log_info "Запуск полной настройки рабочей станции (RDP + GUI + Cursor)"
log_info "=========================================================="

require_root

# --- Проверка SUDO_USER ---
if [ -z "${SUDO_USER:-}" ]; then
  log_error "\$SUDO_USER не установлен. Запустите через sudo от имени пользователя."
  exit 1
fi

confirm_action "Продолжить установку (GUI, RDP, раскладка, Cursor)?"

AUTO_CONFIRM=1 bash "$ROLES_DIR/00-base-system/install.sh"
AUTO_CONFIRM=1 bash "$ROLES_DIR/01-gui-cinnamon/install.sh"
AUTO_CONFIRM=1 bash "$ROLES_DIR/02-remote-access/install.sh"
AUTO_CONFIRM=1 bash "$ROLES_DIR/03-desktop-ux/install.sh"
AUTO_CONFIRM=1 bash "$ROLES_DIR/10-ide-cursor/install.sh"

log_info "=========================================================="
log_info "Настройка завершена."
log_info "Перезагрузите систему для применения изменений."
log_info "После этого подключайтесь по RDP."
log_info "=========================================================="
