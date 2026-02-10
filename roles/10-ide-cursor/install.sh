#!/bin/bash
# Role: 10-ide-cursor
# Description: Installs the Cursor IDE.

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
confirm_action "Установить IDE Cursor?"

log_info "ROLE: 10-ide-cursor"

CURSOR_DEB="$(mktemp /tmp/cursor.XXXXXX.deb)"
cleanup() {
  rm -f "$CURSOR_DEB"
}
trap cleanup EXIT

# --- Проверка wget ---
if ! command -v wget >/dev/null 2>&1; then
  log_info "wget не найден. Установка wget..."
  apt-get update
  apt-get install -y wget
fi

# --- Установка Cursor ---
log_info "Скачивание Cursor IDE..."
if wget --https-only --tries=3 --timeout=60 "https://cursor.com/download/linux-deb-x64" -O "$CURSOR_DEB"; then
  if [ -s "$CURSOR_DEB" ] && dpkg-deb --info "$CURSOR_DEB" >/dev/null 2>&1; then
    if apt-get install -y "$CURSOR_DEB"; then
      log_info "Cursor IDE установлен успешно."
    else
      log_warn "Установка Cursor IDE завершилась ошибкой."
    fi
  else
    log_warn "Скачанный файл не является валидным .deb или пустой."
    log_warn "Попробуйте установить вручную: https://cursor.com/downloads"
  fi
else
  log_warn "Скачивание Cursor IDE не удалось (wget)."
  log_warn "Попробуйте установить вручную: https://cursor.com/downloads"
fi

log_info "ROLE: 10-ide-cursor - COMPLETE"
