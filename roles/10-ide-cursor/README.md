# Role: 10-ide-cursor

## Назначение

Установка IDE Cursor из официального `.deb`.

### Официальные источники

- https://cursor.com/downloads
- https://manpages.ubuntu.com/manpages/noble/en/man8/apt-get.8.html

## Действия

1. **Подготовка:** устанавливает `wget`, если он отсутствует.
2. **Загрузка:** скачивает `.deb` с официального сайта `cursor.com`.
3. **Установка:** выполняет `apt-get install` для локального файла.
4. **Обработка ошибок:** выводит предупреждение при недоступности сервера.

### Официальные источники

- https://cursor.com/downloads
- https://manpages.ubuntu.com/manpages/noble/en/man1/wget.1.html

## Запуск

Скрипт требует root и запрашивает подтверждение. Для безинтерактивного запуска используйте `AUTO_CONFIRM=1`.

Пример (интерактивно):

```bash
sudo bash ./roles/10-ide-cursor/install.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./roles/10-ide-cursor/install.sh
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html

## Устранение проблем

Если установка не удалась, скачайте `.deb` вручную и установите:

```bash
sudo apt install ./имя-скачанного-файла.deb
```

### Официальные источники

- https://cursor.com/downloads
