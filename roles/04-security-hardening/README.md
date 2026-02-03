# Role: 04-security-hardening

## Назначение

Базовый hardening Ubuntu Server: фаервол, защита от брутфорса, автообновления.

### Официальные источники

- https://help.ubuntu.com/community/UFW
- https://github.com/fail2ban/fail2ban

## Действия

1. **Установка пакетов:** `ufw`, `unattended-upgrades`, `fail2ban`.
2. **Автообновления:** создается `/etc/apt/apt.conf.d/20auto-upgrades`.
3. **UFW:** deny incoming, allow outgoing, разрешены SSH (limit) и RDP (3389).
4. **SSH hardening:** `PermitRootLogin no`, перезапуск SSH.
5. **Fail2Ban:** `jail.local` для `sshd` и `xrdp`.

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/ufw.8.html
- https://manpages.ubuntu.com/manpages/noble/en/man8/sshd_config.5.html
- https://github.com/fail2ban/fail2ban

## Запуск

Скрипт требует root и запрашивает подтверждение. Для безинтерактивного запуска используйте `AUTO_CONFIRM=1`.

Пример (интерактивно):

```bash
sudo bash ./roles/04-security-hardening/install.sh
```

Пример (без подтверждений):

```bash
AUTO_CONFIRM=1 sudo bash ./roles/04-security-hardening/install.sh
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/sudo.8.html

## Проверка

Примеры проверки состояния:

```bash
sudo ufw status verbose
sudo fail2ban-client status sshd
```

### Официальные источники

- https://manpages.ubuntu.com/manpages/noble/en/man8/ufw.8.html
- https://manpages.ubuntu.com/manpages/noble/en/man1/fail2ban-client.1.html
