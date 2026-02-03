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
2. **Настройка прав:** пользователь `xrdp` — в группу `ssl-cert`; пользователь, запускающий скрипт (`SUDO_USER`), — в группы `video` и `render` (доступ к GPU в RDP-сессии).
3. **Сессия по RDP:** создаётся `~/.xsession` пользователя с запуском `cinnamon-session` и переменными `XDG_SESSION_TYPE=x11`, `GDK_BACKEND=x11`. При входе по RDP вызывается `/etc/X11/Xsession`, он выполняет `~/.xsession` — так устраняется ошибка «Oh no! Something has gone wrong».
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

## Устранение неполадок

В логе Xorg (`~/.xorgxrdp.10.log`) могут быть строки:
- `systemd-logind: failed to take device /dev/dri/card1: Operation not permitted`
- `rdpPreInit: /dev/dri/renderD128 open failed`

Это значит, что RDP-сессия не получила доступ к GPU и работает на программном рендеринге. Чтобы попытаться получить доступ к GPU, пользователь должен быть в группах `video` и `render` (роль добавляет его при запуске через `sudo` от этого пользователя). После добавления в группы нужен новый вход по RDP или перезагрузка. Если локальная сессия (LightDM) уже заняла GPU, RDP-сессия может по-прежнему использовать только программный рендер.

**Экран «Oh no! Something has gone wrong» при входе по RDP** — сессия Cinnamon падает, т.к. Xsession в RDP не поднимает окружение корректно. Роль создаёт у пользователя `~/.xsession` с прямым запуском `cinnamon-session`. Если ошибка уже есть на машине, создайте вручную (под пользователем, который входит по RDP):

```bash
sudo -u roman bash -c 'cat > ~/.xsession << "EOF"
#!/bin/sh
[ -r /etc/profile ] && . /etc/profile
[ -r "$HOME/.profile" ] && . "$HOME/.profile"
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
exec cinnamon-session
EOF
chmod 755 ~/.xsession'
```

Затем переподключитесь по RDP.
