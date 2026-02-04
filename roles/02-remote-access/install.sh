#!/bin/bash
# Role: 02-remote-access
# Description: Installs and configures xrdp to work with MATE Desktop.

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
confirm_action "Установить и настроить RDP (xrdp) для MATE?"

log_info "ROLE: 02-remote-access"

# --- Установка xrdp ---
log_info "Установка xrdp..."
apt-get install -y xrdp

log_info "Добавление пользователя xrdp в группу ssl-cert..."
adduser xrdp ssl-cert

# --- Группы для RDP-сессии ---
RDP_USER="${SUDO_USER:-}"
if [ -n "$RDP_USER" ]; then
  # video/render для GPU
  for g in video render; do
    if getent group "$g" >/dev/null 2>&1; then
      usermod -aG "$g" "$RDP_USER" 2>/dev/null && log_info "Пользователь $RDP_USER добавлен в группу $g." || true
    fi
  done
  # netdev для NetworkManager (Wi‑Fi без пароля)
  if getent group netdev >/dev/null 2>&1; then
    usermod -aG netdev "$RDP_USER" 2>/dev/null && log_info "Пользователь $RDP_USER добавлен в группу netdev." || true
  fi
  log_info "Для применения групп перезайдите в RDP или перезагрузите систему."
else
  log_warn "SUDO_USER не задан. Добавьте пользователя RDP в группы video,render,netdev: usermod -aG video,render,netdev <user>"
fi

# --- Пользовательский .xsession для RDP ---
if [ -n "$RDP_USER" ]; then
  RDP_HOME="$(getent passwd "$RDP_USER" | cut -d: -f6)"
  if [ -n "$RDP_HOME" ] && [ -d "$RDP_HOME" ]; then
    XSESSION_FILE="$RDP_HOME/.xsession"
    cat <<'XSESSION_EOF' > "$XSESSION_FILE"
#!/bin/sh
# Сессия MATE для xrdp (dbus-run-session устраняет "Could not acquire name on session bus")
[ -r /etc/profile ] && . /etc/profile
[ -r "$HOME/.profile" ] && . "$HOME/.profile"
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
exec dbus-run-session -- mate-session
XSESSION_EOF
    chmod 755 "$XSESSION_FILE"
    chown "$RDP_USER:$RDP_USER" "$XSESSION_FILE"
    log_info "Создан $XSESSION_FILE для пользователя $RDP_USER."
  else
    log_warn "Домашний каталог пользователя $RDP_USER не найден, .xsession не создан."
  fi
fi

log_info "Старт сессии по RDP идёт через ~/.xsession (dbus-run-session -- mate-session)."

# --- Служба xrdp ---
log_info "Включение и перезапуск службы xrdp..."
systemctl enable xrdp
systemctl restart xrdp

log_info "ROLE: 02-remote-access - COMPLETE"
