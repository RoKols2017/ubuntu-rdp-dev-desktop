# Сценарии использования

Этот каталог содержит сценарии-оркестраторы для комплексной настройки.

## `full-rdp-dev-desktop.sh`

### Назначение

Полная настройка рабочей станции: GUI, RDP, раскладка `us/ru`, установка Cursor.

### Что делает

Запускает роли по порядку:
1. `00-base-system`
2. `01-gui-mate`
3. `02-remote-access`
4. `03-desktop-ux`
5. `10-ide-cursor`

### Как использовать

Скрипт должен запускаться через `sudo` от имени целевого пользователя (требуется `SUDO_USER`).

Пример (интерактивно):

```bash
sudo bash ./use-cases/full-rdp-dev-desktop.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./use-cases/full-rdp-dev-desktop.sh
```

После завершения рекомендуется перезагрузка.

### Официальные источники

- https://ubuntu.com/server/docs
- https://ubuntu-mate.org/
- https://github.com/neutrinolabs/xrdp
- https://cursor.com/downloads

---

## `harden-server.sh`

### Назначение

Базовая настройка системы и hardening (фаервол, защита SSH/RDP, автообновления).

### Что делает

Запускает роли по порядку:
1. `00-base-system`
2. `04-security-hardening`

Результат:
- UFW активен, открыты порты SSH (22) и RDP (3389)
- Fail2Ban защищает SSH и xrdp
- Вход под root по SSH отключён
- Автообновления безопасности включены

### Как использовать

Пример (интерактивно):

```bash
sudo bash ./use-cases/harden-server.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./use-cases/harden-server.sh
```

### Официальные источники

- https://help.ubuntu.com/community/UFW
- https://github.com/fail2ban/fail2ban
