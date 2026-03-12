# Домашнее задание к занятию "Система мониторинга Zabbix" - `Грекова Иоланта`
      - для корректного добавления скриншотов воспользуйтесь [инструкцией "Как вставить скриншот в шаблон с решением](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md)
      - при оформлении используйте возможности языка разметки md (коротко об этом можно посмотреть в [инструкции  по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md))
   4. После завершения работы над домашним заданием сделайте коммит (`git commit -m "comment"`) и отправьте его на Github (`git push origin`);
   5. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.

### Задание 1

Успешный вход в веб-интерфейс Zabbix с учетными данными Admin/zabbix:

`При необходимости прикрепитe сюда скриншоты
![Zabbix login](/home/ssvssssvss/Система мониторинга Zabbix/zabbix_login.png)`

Пошаговое выполнение второго задания. В моем случае все настройки производятся внутри docker контейнера, поэтому может немного отличаться от команд из лекций.
1. sudo apt update
2. mkdir -p ~/zabbix-docker #создание директории для проекта
3. cd ~/zabbix-docker
4. sudo nano docker-compose.yml #создание файла docker-compose
5. docker compose up -d
6. docker compose ps #проверка статуса контейнера

Настройка доступа к веб-интерфейсу:
URL: http://localhost:8080
Логин: Admin
Пароль: zabbix

**Примечания**
Все компоненты запущены в Docker контейнерах
Используется PostgreSQL 15 в качестве базы данных
Версия Zabbix: 7.2 LTS
Веб-сервер: Apache с PHP


### Задание 2
Приложите скриншот раздела Configuration > Hosts, где видно, что агенты подключены к серверу.
![Zabbix hosts](/home/ssvssssvss/Система мониторинга Zabbix/hosts.png)`
Приложите в файл README.md скриншот лога zabbix agent, где видно, что он работает с сервером.
![VM metrics](/home/ssvssssvss/Система мониторинга Zabbix/metrics.png)`
Приложите в файл README.md текст использованных команд в GitHub.

VM1 — установка Zabbix Server
sudo apt update
sudo apt upgrade -y

wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
sudo apt update
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mysql-server -y

Настройка базы данных
sudo mysql
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbixpass';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
EXIT;
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p zabbix

Настройка Zabbix Server
sudo nano /etc/zabbix/zabbix_server.conf
DBPassword=zabbixpass

sudo systemctl restart zabbix-server
sudo systemctl restart apache2
sudo systemctl restart zabbix-agent

sudo systemctl enable zabbix-server
sudo systemctl enable apache2
sudo systemctl enable zabbix-agent

VM2 — установка Zabbix Agent

sudo apt update
sudo apt install zabbix-agent -y

Настройка агента
sudo nano /etc/zabbix/zabbix_agentd.conf
Server=192.168.1.27
ServerActive=192.168.1.27
Hostname=host2

sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent

Проверка работы агента
sudo apt install zabbix-get -y
zabbix_get -s 192.168.1.28 -k system.hostname
Ответ:
vm-gold-ubuntu-22

Проверка лога агента
sudo tail -n 30 /var/log/zabbix/zabbix_agentd.log
Проверка порта агента
ss -tulpn | grep 10050
Проверка данных в Zabbix
В веб-интерфейсе:
Configuration → Hosts
Monitoring → Latest data
