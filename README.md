Домашнее задание по лекции "Защита сети". Грекова Иоланта.

**Задание 1**
*Проведите разведку системы и определите, какие сетевые службы запущены на защищаемой системе:*
*sudo nmap -sA < ip-адрес >*
*sudo nmap -sT < ip-адрес >*
*sudo nmap -sS < ip-адрес >*
*sudo nmap -sV < ip-адрес >*
*По желанию можете поэкспериментировать с опциями: https://nmap.org/man/ru/man-briefoptions.html.*
*В качестве ответа пришлите события, которые попали в логи Suricata и Fail2Ban, прокомментируйте результат.*


**Ответ**
sudo nmap -sA 10.0.2.15: Все 1000 TCP портов unfiltered
sudo nmap -sT 10.0.2.15: Все 1000 TCP портов closed (conn-refused)
sudo nmap -sS 10.0.2.15: Все 1000 TCP портов closed (reset)
sudo nmap -sV 10.0.2.15: Все 1000 TCP портов closed (reset)
Вывод: На защищаемой системе отсутствуют открытые TCP-порты и доступные сервисы.
_____

**События в логах Suricata**
/var/log/suricata/fast.log:
03/19/2026-14:41:09.405868  [**] ET SCAN Suspicious inbound to PostgreSQL port 5432
03/19/2026-14:41:09.411587  [**] ET SCAN Potential VNC Scan 5800-5820
03/19/2026-14:41:20.696538  [**] ET SCAN Suspicious inbound to MySQL port 3306
03/19/2026-14:41:20.702879  [**] ET SCAN Suspicious inbound to Oracle SQL port 1521
03/19/2026-14:41:20.706747  [**] ET SCAN Suspicious inbound to MSSQL port 1433
03/19/2026-14:41:27.381028  [**] ET SCAN Suspicious inbound to MySQL port 3306
03/19/2026-14:41:27.393854  [**] ET SCAN Suspicious inbound to PostgreSQL port 5432

Даже при закрытых портах Suricata регистрирует факт перебора. Попытки подключения были направлены на популярные сервисные порты. Suricata зафиксировала сканирование портов с Kali (10.0.2.4)

**События в логах Fail2ban**
/var/log/fail2ban.log
2026-03-19 10:54:41,448 fail2ban.jail           INFO    Creating new jail 'sshd'
2026-03-19 10:54:41,462 fail2ban.jail           INFO    Jail 'sshd' uses pyinotify {}
2026-03-19 10:54:41,477 fail2ban.filter         INFO    Added logfile: '/var/log/auth.log'
2026-03-19 10:54:41,481 fail2ban.jail           INFO    Jail 'sshd' started

Реагирует только на повторные неудачные логины (SSH, FTP и т.д.). Fail2ban не зафиксировал попыток брутфорса, так как nmap не выполнял попыток аутентификации.

**Задание 2**
*Проведите атаку на подбор пароля для службы SSH:*
*В качестве ответа пришлите события, которые попали в логи Suricata и Fail2Ban, прокомментируйте результат.*

**Ответ**
hydra -L ~/user.txt -P ~/pass.txt 10.0.2.15 ssh
Выполнено: 30 попыток авторизации
Успешных входов: 0

События в логах Suricata
**Логи из /var/log/suricata/fast.log:**
ET SCAN Potential SSH Scan OUTBOUND {TCP} 10.0.2.4 -> 10.0.2.15:22
ET SCAN Potential SSH Scan OUTBOUND {TCP} 10.0.2.4 -> 10.0.2.15:22
ET SCAN Potential SSH Scan OUTBOUND {TCP} 10.0.2.4 -> 10.0.2.15:22
...
(множественные повторяющиеся события)

Зафиксированы множественные подключения к порту 22 (SSH).
Источник: 10.0.2.4 (Kali).
Назначение: 10.0.2.15 (целевая машина).
Каждая попытка Hydra → отдельное событие.
Suricata распознала паттерн brute-force / сканирования SSH

**Логи из /var/log/fail2ban.log**
Fail2ban зафиксировал множественные неудачные попытки входа:
2026-03-19 23:54:01,894 fail2ban.filter [3686]: INFO [sshd] Found 10.0.2.4 -
2026-03-19 23:54:01 2026-03-19 23:54:01,895 fail2ban.filter [3686]: INFO [sshd] Found 10.0.2.4 - 
2026-03-19 23:54:01 2026-03-19 23:54:01,895 fail2ban.filter [3686]: INFO [sshd] Found 10.0.2.4 - 
2026-03-19 23:54:01 2026-03-19 23:54:01,895 fail2ban.filter [3686]: INFO [sshd] Found 10.0.2.4 - 
2026-03-19 23:54:01 2026-03-19 23:54:01,895 fail2ban.filter [3686]: INFO [sshd] Found 10.0.2.4 - 
2026-03-19 23:54:01 2026-03-19 23:54:01,895 fail2ban.filter [3686]: INFO [sshd] Found 10.0.2.4 - 
2026-03-19 23:54:01 2026-03-19 23:54:02,605 fail2ban.filter [3686]: INFO [sshd] Found 10.0.2.4 - 
2026-03-19 23:54:02 2026-03-19 23:54:02,606 fail2ban.filter [3686]: INFO [sshd] Found 10.0.2.4 - 
2026-03-19 23:54:02 2026-03-19 23:54:02,606 fail2ban.filter [3686]: INFO [sshd] Found 10.0.2.4 - 
2026-03-19 23:54:02 2026-03-19 23:54:02,677 fail2ban.actions [3686]: NOTICE [sshd] 
10.0.2.4 already banned

После превышения порога (maxretry) IP был заблокирован:
Found 10.0.2.4
already banned

Fail2ban обнаружил превышение допустимого количества неудачных попыток аутентификации и автоматически заблокировал IP-адрес атакующего узла (10.0.2.4).

