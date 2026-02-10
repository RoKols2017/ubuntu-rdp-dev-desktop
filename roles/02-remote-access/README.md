# Role: 02-remote-access

## Назначение

Настройка RDP-доступа через `xrdp` для запуска сессии MATE Desktop.

### Официальные источники

- https://github.com/neutrinolabs/xrdp
- https://manpages.ubuntu.com/manpages/noble/en/man1/systemctl.1.html

## Зависимости

- `01-gui-mate`

### Официальные источники

- https://ubuntu-mate.org/

## Действия

1. **Установка `xrdp`:** устанавливает пакет `xrdp`.
2. **Настройка прав:** пользователь `xrdp` — в группу `ssl-cert`; пользователь, запускающий скрипт (`SUDO_USER`), — в группы `video`, `render` (GPU) и `netdev` (NetworkManager).
3. **Сессия по RDP:** создаётся `~/.xsession` пользователя с запуском `dbus-run-session -- mate-session` (D-Bus сессии нужен, иначе «Could not acquire name on session bus» и чёрный экран). При входе по RDP вызывается `/etc/X11/Xsession`, он выполняет `~/.xsession`.
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

Это значит, что RDP-сессия не получила доступ к GPU и работает на программном рендеринге. Чтобы попытаться получить доступ к GPU, пользователь должен быть в группах `video` и `render` (роль добавляет его при запуске через `sudo` от этого пользователя). После добавления в группы нужен новый вход по RDP или перезагрузка.

**«Could not acquire name on session bus» и после OK чёрный экран** — в `~/.xsession` должен быть запуск через `dbus-run-session -- mate-session`, а не просто `mate-session`. Перезапустите роль или исправьте файл вручную (см. блок ниже).

**По RDP видны только обои, нет меню и значков на рабочем столе** — проверьте наличие файла `~/.xsession`:

```bash
ls -l ~/.xsession
cat ~/.xsession
```

Файл должен содержать (обязательно `dbus-run-session`, иначе «Could not acquire name on session bus» и чёрный экран):
```bash
#!/bin/sh
[ -r /etc/profile ] && . /etc/profile
[ -r "$HOME/.profile" ] && . "$HOME/.profile"
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
exec dbus-run-session -- mate-session
```

Если файл отсутствует или неправильный, перезапустите роль:
```bash
sudo bash ./roles/02-remote-access/install.sh
```

**Локальный вход (LightDM): пароль не принимается** — часто из‑за раскладки (например, включена английская, вводите русские буквы) или клавиши Fn (на ноутбуках Fn может переопределять цифры/символы). Для теста можно временно задать простой пароль из латинских букв и цифр (без спецсимволов):

```bash
# Под пользователем root или по SSH
sudo passwd <user>
# Введите новый пароль дважды (только латиница/цифры, например test123)
```

После проверки входа смените пароль на более надёжный: `passwd` от имени пользователя или `sudo passwd <user>`.
