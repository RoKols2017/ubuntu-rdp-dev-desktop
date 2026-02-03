#!/bin/bash
# Role: 00-base-system
# Description: Updates the system, installs basic utilities, and sets the locale.

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
confirm_action "Выполнить базовую настройку системы (обновление и установка утилит)?"

log_info "ROLE: 00-base-system"

# --- Обновление системы ---
log_info "Обновление списка пакетов..."
apt-get update

log_info "Установка обновлений..."
apt-get upgrade -y

# --- Установка утилит ---
log_info "Установка базовых утилит..."
apt-get install -y git curl wget htop unzip ca-certificates software-properties-common

# --- Локаль ---
log_info "Настройка локали en_US.UTF-8..."
localectl set-locale LANG=en_US.UTF-8

# --- Отключение спящего режима (ноутбуки и мини ПК) ---
log_info "Отключение спящего режима и гибернации..."
mkdir -p /etc/systemd/logind.conf.d
cat <<'EOF' > /etc/systemd/logind.conf.d/99-no-sleep.conf
[Login]
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
IdleAction=ignore
IdleActionSec=0
EOF

# Маски целей, чтобы система не уходила в сон по запросу
for t in sleep suspend hibernate hybrid-sleep; do
  systemctl mask "${t}.target" 2>/dev/null || true
done

log_info "ROLE: 00-base-system - COMPLETE"
