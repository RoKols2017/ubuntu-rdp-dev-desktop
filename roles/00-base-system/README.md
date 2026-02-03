# Role: 00-base-system

## Назначение

Базовая настройка системы: обновление пакетов, установка утилит, локаль `en_US.UTF-8`.

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/apt-get.8.html
- https://manpages.ubuntu.com/manpages/noble/en/man1/localectl.1.html

## Действия

1. **Обновление пакетов:** выполняет `apt-get update` и `apt-get upgrade`.
2. **Установка утилит:** `git`, `curl`, `wget`, `htop`, `unzip`, `ca-certificates`, `software-properties-common`.
3. **Настройка локали:** `localectl set-locale LANG=en_US.UTF-8`.

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/apt-get.8.html
- https://manpages.ubuntu.com/manpages/noble/en/man1/localectl.1.html
- https://packages.ubuntu.com/

## Запуск

Скрипт требует root и запрашивает подтверждение. Для безинтерактивного запуска используйте `AUTO_CONFIRM=1`.

Пример (интерактивно):

```bash
sudo bash ./roles/00-base-system/install.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./roles/00-base-system/install.sh
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html
