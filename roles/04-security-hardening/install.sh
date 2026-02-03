#!/bin/bash
# Role: 04-security-hardening
# Description: Applies basic security best practices to the server.

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
confirm_action "Применить hardening (UFW, Fail2Ban, отключение root по SSH)?"

log_info "ROLE: 04-security-hardening"

# --- 1. Установка пакетов безопасности ---
log_info "Установка UFW, unattended-upgrades, fail2ban..."
apt-get update
apt-get install -y ufw unattended-upgrades fail2ban

# --- 2. Автообновления ---
log_info "Включение автоматических обновлений безопасности..."
cat <<EOF > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

# --- 3. Фаервол (UFW) ---
log_info "Настройка фаервола (UFW)..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw limit ssh
ufw allow 3389/tcp
ufw --force enable

# --- 4. SSH hardening ---
log_info "Усиление конфигурации SSH..."
sed -i.bak -E 's/^#?PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config
log_info "Перезапуск службы SSH..."
systemctl restart ssh

# --- 5. Fail2Ban ---
log_info "Настройка Fail2Ban..."
cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true

[xrdp]
enabled = true
port = 3389
logpath = /var/log/xrdp-sesman.log
EOF

log_info "Включение и перезапуск Fail2Ban..."
systemctl enable fail2ban
systemctl restart fail2ban

log_info "ROLE: 04-security-hardening - COMPLETE"
