Домашнее задание к занятию «Система мониторинга Zabbix». Грекова Иоланта.

**Задание 1**
**Установите Zabbix Server с веб-интерфейсом.**

Процесс выполнения
Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
Установите PostgreSQL. Для установки достаточна та версия, что есть в системном репозитороии Debian 11.
Пользуясь конфигуратором команд с официального сайта, составьте набор команд для установки последней версии Zabbix с поддержкой PostgreSQL и Apache.
Выполните все необходимые команды для установки Zabbix Server и Zabbix Web Server.
Требования к результатам
Прикрепите в файл README.md скриншот авторизации в админке.
Приложите в файл README.md текст использованных команд в GitHub.

**Ответ**
![Авторизация в админке Zabbix](https://github.com/ssvssssvss/-DDL-DML-/blob/CS/adminzabbix.PNG)

```bash
# Установка PostgreSQL из системного репозитория Debian 11
sudo apt update
sudo apt install -y postgresql postgresql-contrib
# Добавление репозитория Zabbix
sudo wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian11_all.deb
sudo dpkg -i zabbix-release_latest_7.0+debian11_all.deb
sudo apt update
# Установка Zabbix Server и Web Server с поддержкой PostgreSQL и Apache
sudo apt install -y zabbix-server-pgsql zabbix-frontend-php php-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent
# Создание базы данных и пользователя для Zabbix
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix
# Импорт начальной схемы базы данных
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
# Настройка пароля базы данных в конфигурации Zabbix Server
sudo sed -i 's/# DBPassword=/DBPassword=your_password/' /etc/zabbix/zabbix_server.conf
# Запуск и добавление в автозагрузку служб
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2
```

**Задание 2**
**Установите Zabbix Agent на два хоста.**

Процесс выполнения
Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
Установите Zabbix Agent на 2 вирт.машины, одной из них может быть ваш Zabbix Server.
Добавьте Zabbix Server в список разрешенных серверов ваших Zabbix Agentов.
Добавьте Zabbix Agentов в раздел Configuration > Hosts вашего Zabbix Servera.
Проверьте, что в разделе Latest Data начали появляться данные с добавленных агентов.
Требования к результатам
Приложите в файл README.md скриншот раздела Configuration > Hosts, где видно, что агенты подключены к серверу
Приложите в файл README.md скриншот лога zabbix agent, где видно, что он работает с сервером
Приложите в файл README.md скриншот раздела Monitoring > Latest data для обоих хостов, где видны поступающие от агентов данные.
Приложите в файл README.md текст использованных команд в GitHub.

**Ответ**
# На Zabbix Server
sudo apt install -y zabbix-agent
# На второй виртуальной машине (установка агента)
# Добавление репозитория Zabbix
sudo wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.0+debian11_all.deb
sudo dpkg -i zabbix-release_latest_7.0+debian11_all.deb
sudo apt update
# Установка Zabbix Agent
sudo apt install -y zabbix-agent
# На обеих машинах - редактирование конфигурации агента
sudo nano /etc/zabbix/zabbix_agentd.conf
# Изменить строки:
Server=127.0.0.1 -> Server=IP_Zabbix_сервера
ServerActive=127.0.0.1 -> ServerActive=IP_Zabbix_сервера
Hostname=имя_хоста_агента
# Перезапуск агента на обеих машинах
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent

![Скриншот раздела Configuration > Hosts, где видно, что агенты подключены к серверу](https://github.com/ssvssssvss/-DDL-DML-/blob/CS/hosts.PNG)

![скриншот лога zabbix agent, где видно, что он работает с сервером](https://github.com/ssvssssvss/-DDL-DML-/blob/CS/logs.PNG)

![скриншот раздела Monitoring > Latest data для обоих хостов, где видны поступающие от агентов данные](https://github.com/ssvssssvss/-DDL-DML-/blob/CS/monitoring.PNG)
