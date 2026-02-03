# Role: 01-gui-cinnamon

## Назначение

Установка графического окружения Cinnamon и X.org, а также фикса PolicyKit для RDP.

### Официальные источники

- https://projects.linuxmint.com/cinnamon/
- https://packages.ubuntu.com/

## Зависимости

- `00-base-system` (рекомендуется)

### Официальные источники

- https://packages.ubuntu.com/

## Действия

1. **Установка пакетов:** `cinnamon-desktop-environment` и `xorg`.
2. **Применение фикса для RDP:** копирует правило PolicyKit `02-allow-colord.rules` в `/etc/polkit-1/rules.d/`.

### Официальные источники

- https://www.freedesktop.org/wiki/Software/polkit/
- https://packages.ubuntu.com/

## Запуск

Скрипт требует root и запрашивает подтверждение. Для безинтерактивного запуска используйте `AUTO_CONFIRM=1`.

Пример (интерактивно):

```bash
sudo bash ./roles/01-gui-cinnamon/install.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./roles/01-gui-cinnamon/install.sh
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html
