# Ubuntu Workstation Setup

Проект автоматической настройки рабочей станции Ubuntu Server 24.04 LTS для удалённой разработки и RDP-доступа.

## Цель

- Графический интерфейс Cinnamon
- RDP-доступ с Windows
- Раскладка `us/ru` с переключением `Ctrl+Shift`
- IDE Cursor для разработки

### Официальные источники

- https://ubuntu.com/server/docs
- https://projects.linuxmint.com/cinnamon/
- https://github.com/neutrinolabs/xrdp
- https://cursor.com/downloads
- https://manpages.ubuntu.com/manpages/noble/en/man1/setxkbmap.1.html

## Архитектура

- `roles/` — отдельные роли с `install.sh` и `README.md`
- `use-cases/` — сценарии-оркестраторы для комплексной настройки
- Все скрипты — bash; по умолчанию интерактивные подтверждения
- Для безинтерактивного запуска используйте `AUTO_CONFIRM=1`

### Официальные источники

- https://www.gnu.org/software/bash/manual/
- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html

## Доступные роли

| Роль | Описание |
|------|----------|
| **00-base-system** | Базовая настройка: обновление, утилиты, локаль en_US.UTF-8 |
| **01-gui-cinnamon** | Графическая оболочка Cinnamon + X.org |
| **02-remote-access** | RDP-доступ через xrdp |
| **03-desktop-ux** | UX: шрифты Fira Code, раскладка us/ru (Ctrl+Shift), Firefox |
| **04-security-hardening** | Усиление безопасности системы |
| **10-ide-cursor** | IDE Cursor для разработки |

### Официальные источники

- https://packages.ubuntu.com/
- https://manpages.ubuntu.com/manpages/noble/en/man1/localectl.1.html

## Быстрый старт

Пример (интерактивный запуск):

```bash
sudo bash ./use-cases/full-rdp-dev-desktop.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./use-cases/full-rdp-dev-desktop.sh
```

После завершения — перезагрузить систему и подключиться по RDP.

### Официальные источники

- https://ubuntu.com/server/docs
- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html

## Выборочная установка

Роли можно запускать отдельно. Для `03-desktop-ux` запускать через `sudo` от имени целевого пользователя (требуется `SUDO_USER`).

Пример (базовая настройка):

```bash
sudo bash ./roles/00-base-system/install.sh
```

Пример (пользовательские настройки рабочего стола):

```bash
sudo bash ./roles/03-desktop-ux/install.sh
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html