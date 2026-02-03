#!/bin/bash
# Use Case: Harden Server
# This script applies base system setup and security hardening.

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
log_info "Запуск базовой настройки и hardening сервера"
log_info "=========================================================="

require_root
confirm_action "Продолжить hardening (UFW, Fail2Ban, SSH hardening)?"

AUTO_CONFIRM=1 bash "$ROLES_DIR/00-base-system/install.sh"
AUTO_CONFIRM=1 bash "$ROLES_DIR/04-security-hardening/install.sh"

log_info "=========================================================="
log_info "Hardening завершён."
log_info "UFW активен, Fail2Ban мониторит службы."
log_info "Рекомендуется перезагрузка."
log_info "=========================================================="
