# Role: 03-desktop-ux

## Назначение

Пользовательские настройки: шрифты, раскладка `us/ru`, браузер по умолчанию. Все изменения применяются к домашнему каталогу пользователя.

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man1/setxkbmap.1.html
- https://www.freedesktop.org/wiki/Software/xdg-utils/

## Зависимости

- `01-gui-cinnamon` (рекомендуется)
- X.org (для `setxkbmap`)

### Официальные источники

- https://packages.ubuntu.com/

## Действия

1. **Установка шрифтов и утилит:** `fonts-firacode`, `xdg-utils`.
2. **Firefox (если отсутствует):** устанавливается пакет `firefox`.
3. **Раскладка:** создается `~/.config/autostart/setxkbmap.desktop` для `us,ru` + `Ctrl+Shift`.
4. **Браузер по умолчанию:** через `xdg-settings` и `xdg-mime` при наличии `.desktop` файла Firefox.

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man1/setxkbmap.1.html
- https://www.freedesktop.org/wiki/Software/xdg-utils/
- https://packages.ubuntu.com/

## Запуск

Скрипт требует root и запускается через `sudo` от имени целевого пользователя (используется `SUDO_USER`). Для безинтерактивного запуска используйте `AUTO_CONFIRM=1`.

Пример (интерактивно):

```bash
sudo bash ./roles/03-desktop-ux/install.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./roles/03-desktop-ux/install.sh
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html
