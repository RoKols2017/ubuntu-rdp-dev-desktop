#!/bin/bash
# Role: 03-desktop-ux
# Description: Applies user-level tweaks like fonts, keyboard layout, and default browser.

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
if [ -z "${SUDO_USER:-}" ]; then
  log_error "SUDO_USER не установлен. Запустите скрипт через sudo от имени целевого пользователя."
  exit 1
fi

confirm_action "Применить пользовательские настройки (шрифты, раскладка, браузер по умолчанию)?"

# --- Определение целевого пользователя ---
TARGET_USER="$SUDO_USER"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
if [ -z "$TARGET_HOME" ]; then
  log_error "Не удалось определить домашний каталог пользователя: $TARGET_USER"
  exit 1
fi

log_info "ROLE: 03-desktop-ux"
log_info "Целевой пользователь: $TARGET_USER"

# --- Шрифты и утилиты ---
log_info "Установка шрифтов и утилит..."
apt-get install -y fonts-firacode xdg-utils

# --- Firefox (если отсутствует) ---
if ! command -v firefox >/dev/null 2>&1; then
  log_info "Firefox не найден. Установка Firefox..."
  if apt-get install -y firefox; then
    log_info "Firefox установлен."
  else
    log_warn "Не удалось установить Firefox. Установите вручную."
  fi
fi

# --- Раскладка клавиатуры ---
log_info "Настройка автозапуска раскладки (us,ru с Ctrl+Shift)..."
AUTOCONFIG_DIR="$TARGET_HOME/.config/autostart"
mkdir -p "$AUTOCONFIG_DIR"
cat <<EOF > "$AUTOCONFIG_DIR/setxkbmap.desktop"
[Desktop Entry]
Name=Set XKB Map on Login
Comment=Forces keyboard layout for RDP sessions
Exec=setxkbmap -layout us,ru -option grp:ctrl_shift_toggle
Type=Application
EOF
chown "$TARGET_USER:$TARGET_USER" "$AUTOCONFIG_DIR/setxkbmap.desktop"

if ! command -v setxkbmap >/dev/null 2>&1; then
  log_warn "setxkbmap не найден. Проверьте установку X.org."
fi

# --- Браузер по умолчанию ---
FIREFOX_DESKTOP=""
if [ -f /var/lib/snapd/desktop/applications/firefox_firefox.desktop ]; then
  FIREFOX_DESKTOP="firefox_firefox.desktop"
elif [ -f /usr/share/applications/firefox.desktop ]; then
  FIREFOX_DESKTOP="firefox.desktop"
fi

if [ -n "$FIREFOX_DESKTOP" ]; then
  if command -v xdg-settings >/dev/null 2>&1 && command -v xdg-mime >/dev/null 2>&1; then
    log_info "Назначение Firefox браузером по умолчанию..."
    sudo -u "$TARGET_USER" xdg-settings set default-web-browser "$FIREFOX_DESKTOP" || log_warn "Не удалось установить браузер по умолчанию."
    sudo -u "$TARGET_USER" xdg-mime default "$FIREFOX_DESKTOP" x-scheme-handler/http || log_warn "Не удалось установить x-scheme-handler/http."
    sudo -u "$TARGET_USER" xdg-mime default "$FIREFOX_DESKTOP" x-scheme-handler/https || log_warn "Не удалось установить x-scheme-handler/https."
  else
    log_warn "xdg-utils не найден. Пропуск настройки браузера по умолчанию."
  fi
else
  log_warn "Файл .desktop для Firefox не найден. Пропуск настройки браузера по умолчанию."
fi

log_info "ROLE: 03-desktop-ux - COMPLETE"
