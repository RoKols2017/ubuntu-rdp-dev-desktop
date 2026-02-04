# Role: 01-gui-mate

## Назначение

Установка графического окружения MATE Desktop и X.org для Ubuntu Server 24.04 LTS.

### Официальные источники

- https://ubuntu-mate.org/
- https://packages.ubuntu.com/

## Зависимости

- `00-base-system` (рекомендуется)

### Официальные источники

- https://packages.ubuntu.com/

## Действия

1. **Установка пакетов:** `ubuntu-mate-core` (легковесная версия MATE) и `xorg`.
2. **LightDM:** установка и переключение на LightDM по умолчанию (лучше работает с RDP).

### Официальные источники

- https://ubuntu-mate.org/
- https://packages.ubuntu.com/

## Запуск

Скрипт требует root и запрашивает подтверждение. Для безинтерактивного запуска используйте `AUTO_CONFIRM=1`.

Пример (интерактивно):

```bash
sudo bash ./roles/01-gui-mate/install.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./roles/01-gui-mate/install.sh
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html

## Устранение неполадок

Если после перезагрузки графический интерфейс не запускается:

1. Перезагрузитесь в консоль (другой TTY: Ctrl+Alt+F3) или восстановление.
2. Войдите под пользователем и выполните:

```bash
sudo apt install -y lightdm
sudo update-alternatives --set x-display-manager /usr/sbin/lightdm
sudo reboot
```

После перезагрузки должен запускаться LightDM и сессия MATE.
