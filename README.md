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
