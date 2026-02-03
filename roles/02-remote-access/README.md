# Role: 02-remote-access

## Назначение

Настройка RDP-доступа через `xrdp` для запуска сессии Cinnamon.

### Официальные источники

- https://github.com/neutrinolabs/xrdp
- https://manpages.ubuntu.com/manpages/noble/en/man1/systemctl.1.html

## Зависимости

- `01-gui-cinnamon`

### Официальные источники

- https://projects.linuxmint.com/cinnamon/

## Действия

1. **Установка `xrdp`:** устанавливает пакет `xrdp`.
2. **Настройка прав:** добавляет пользователя `xrdp` в группу `ssl-cert`.
3. **Настройка сессии:** добавляет запуск `cinnamon-session` в `/etc/xrdp/startwm.sh` (создается `.bak`).
4. **Служба:** включает автозагрузку и перезапускает `xrdp`.

### Официальные источники

- https://github.com/neutrinolabs/xrdp
- https://manpages.ubuntu.com/manpages/noble/en/man1/systemctl.1.html

## Запуск

Скрипт требует root и запрашивает подтверждение. Для безинтерактивного запуска используйте `AUTO_CONFIRM=1`.

Пример (интерактивно):

```bash
sudo bash ./roles/02-remote-access/install.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./roles/02-remote-access/install.sh
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html
