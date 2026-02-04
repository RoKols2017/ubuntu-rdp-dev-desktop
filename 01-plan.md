# План проекта: Ubuntu Workstation Setup

Файл плана создан на основе текущих решений и обсуждений.

## Цель и результат

- Рабочая станция Ubuntu Server 24.04 LTS с GUI
- Раскладка `us/ru` с переключением `Ctrl+Shift`
- Установка IDE Cursor
- Доступ по RDP с Windows

### Официальные источники

- https://ubuntu.com/server/docs

## Принятые решения

- Локаль системы: `en_US.UTF-8` (для совместимости dev-инструментов)
- GUI: MATE Desktop
- RDP: xrdp, запуск `mate-session`
- Раскладка: `setxkbmap -layout us,ru -option grp:ctrl_shift_toggle`
- Cursor: установка официального `.deb` с `cursor.com`

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man1/localectl.1.html
- https://manpages.ubuntu.com/manpages/noble/en/man1/setxkbmap.1.html
- https://ubuntu-mate.org/
- https://github.com/neutrinolabs/xrdp
- https://cursor.com/downloads

## Текущее состояние проекта

- Роли реализованы в `roles/`
- Оркестратор для полной настройки: `use-cases/full-rdp-dev-desktop.sh`
- Оркестратор для харднинга: `use-cases/harden-server.sh`
- Документация актуализирована

### Официальные источники

- https://packages.ubuntu.com/

## План внедрения (шаги)

1. Подготовить репозиторий:

```bash
git clone <REPO_URL> ubuntu-setup
cd ubuntu-setup
```

2. Запустить полный сценарий рабочей станции:

```bash
sudo bash ./use-cases/full-rdp-dev-desktop.sh
sudo reboot
```

3. Узнать IP сервера для RDP:

```bash
hostname -I
```

4. Подключиться по RDP с Windows к IP сервера.

### Официальные источники

- https://ubuntu.com/server/docs

## Проверка (валидация)

```bash
localectl status
systemctl status xrdp --no-pager
ss -tulpn | grep 3389
test -f ~/.config/autostart/setxkbmap.desktop && echo "[OK] setxkbmap autostart"
xdg-settings get default-web-browser
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man1/localectl.1.html
- https://manpages.ubuntu.com/manpages/noble/en/man1/systemctl.1.html
- https://manpages.ubuntu.com/manpages/noble/en/man8/ss.8.html

## Опциональные улучшения

- Применить hardening:

```bash
sudo bash ./use-cases/harden-server.sh
```

- Добавить роль `05-dev-tools` (Docker, Node.js, Python) при необходимости

### Официальные источники

- https://help.ubuntu.com/community/UFW
- https://github.com/fail2ban/fail2ban
- https://docs.docker.com/engine/install/ubuntu/

## Замечания по безопасности

- Не открывать RDP в Интернет без ограничений по IP
- Использовать сильные пароли для всех пользователей
- Использовать UFW для ограничения доступа

### Официальные источники

- https://ubuntu.com/security
- https://help.ubuntu.com/community/UFW
