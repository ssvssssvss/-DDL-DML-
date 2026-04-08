**Дипломная работа по профессии «Системный администратор». Грекова Иоланта.**

Сайт:
1. Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.
2. Виртуальные машины не должны обладать внешним Ip-адресом, те находится во внутренней сети. Доступ к ВМ по ssh через бастион-сервер. Доступ к web-порту ВМ через балансировщик.
Настройка балансировщика:
1. Создайте Target Group, включите в неё две созданных ВМ.
2. Создайте Backend Group, настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP.
3. Создайте HTTP router. Путь укажите — /, backend group — созданную ранее.
4. Создайте Application load balancer для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.
5. Протестируйте сайт curl -v <публичный IP балансера>:80
Мониторинг:
1. Создайте ВМ, разверните на ней Zabbix. На каждую ВМ установите Zabbix Agent, настройте агенты на отправление метрик в Zabbix.
2. Настройте дешборды с отображением метрик, минимальный набор — по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам. 
Логи:
1. Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.
2. Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.
Сеть:
1. Разверните один VPC. Сервера web, Elasticsearch поместите в приватные подсети. Сервера Zabbix, Kibana, application load balancer определите в публичную подсеть.
2. Настройте Security Groups соответствующих сервисов на входящий трафик только к нужным портам.
3. Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh. Эта вм будет реализовывать концепцию bastion host.
4. Исходящий доступ в интернет для ВМ внутреннего контура через NAT-шлюз.
Резервное копирование:
1. Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.

⚠️ В случае недоступности ресурсов Elastic для скачивания рекомендуется разворачивать сервисы с помощью docker контейнеров, основанных на официальных образах.

Критерии сдачи:
1. Инфраструктура отвечает минимальным требованиям, описанным в Задаче.
2. Предоставлен доступ ко всем ресурсам, у которых предполагается веб-страница (сайт, Kibana, Zabbix).
3. Для ресурсов, к которым предоставить доступ проблематично, предоставлены скриншоты, команды, stdout, stderr, подтверждающие работу ресурса.
4. Работа оформлена в отдельном репозитории в GitHub или в Google Docs, разрешён доступ по ссылке.
5. Код размещён в репозитории в GitHub.
6. Работа оформлена так, чтобы были понятны ваши решения и компромиссы.

**Отчет о работе**

*Архитектура решения*
1. В одном VPC развернута инфраструктура:
- Bastion host — доступ по SSH,
- 2 web-сервера (web-1, web-2) — nginx, приватная сеть,
- Zabbix server — мониторинг (публичная сеть),
- Elasticsearch — хранение логов (приватная сеть),
- Kibana — визуализация логов (публичная сеть),
- Application Load Balancer — доступ к сайту.

Файлы Terraform:

![Основной конфигурационный файл main.tf](https://github.com/ssvssssvss/-DDL-DML-/blob/final/terraform/main.tf)

![Описание переменных в variables.tf](https://github.com/ssvssssvss/-DDL-DML-/blob/final/terraform/variables.tf)

![Заданные переменные в terraform.tfvars](https://github.com/ssvssssvss/-DDL-DML-/blob/final/terraform/terraform.tfvars)

Скриншоты:

Созданная VPC:

![VPC](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr2_vpc.PNG)

Настроен NAT:

![NAT](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr4_nat.PNG)

Список настроенных и использованных Security Groups:

![SG](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr5_sg.PNG)

2. Сайт и балансировка:
- Развернуты 2 идентичных веб-сервера,
- Установлен nginx,
- Настроен балансировщик.
 
Проверка:
```bash
curl -v http://158.160.255.157
```

Файлы:
- [inventory.ini](https://github.com/ssvssssvss/-DDL-DML-/blob/final/file/inventory.ini) 
- [nginx-playbook](https://github.com/ssvssssvss/-DDL-DML-/blob/final/file/nginx-playbook.yml)

Скриншоты:

Установленный Ansible на Bastion:
![ansible](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/src8_ansible_version.PNG)

Добавленные в inventory хосты пингуются успешно.

![ansible ping ok](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr10_ansible_ping.PNG)

Установка nginx через плейбук успешна:

![install nginx](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/src11_playbook_ok.PNG)

Проверка корректности установки nginx:
![nginx](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/src12_nginx.PNG)

3. Мониторинг (Zabbix):
- Установлен Zabbix server,
- Установлены агенты на web-серверах,
- Добавлены хосты в Zabbix,
- Настроен HTTP monitoring.

URL: [zabbix](http://46.21.245.24/zabbix/)
Логин: Admin
Пароль: zabbix

Файлы:
- [zabbix-agent.yml](https://github.com/ssvssssvss/-DDL-DML-/blob/final/file/zabbix-agent.yml)

Скриншоты:

Успешная установка zabbix-agent на хосты с использованием ansible:

![playbook agent zbx](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/src14_ansible_ok_zabbixagent.PNG)

Хосты web-1 и web-2 связываются с сервером и отдают метрики (зеленый индикатор ZBX).

![hosts](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/src15_zabbix.PNG)

HTTP scenario (Responce code 200)

![HTTP scenario](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/src16_zabbix_elb.PNG)

Настроенный дашборд на каждую метрику на серверах (CPU, RAM, HTTP):

![Dashdoards](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/src17_zabbix_dasha.PNG)

4. Логи (ELK):
- Развернут Elasticsearch,
- Развернут Kibana (Docker),
- Настроен Filebeat на web-серверах.

Kibana
URL: [kibana](http://kibana.lab.local:5601)  
Логин: elastic
Пароль: cIhsunyKhHaODY=gj0UZ

Elasticsearch (только для проверки работы)
URL: [https://elasticsearch.lab.local:9200](https://elasticsearch.lab.local:9200)  
Через сервисный токен Kibana:
```bash
curl -H "Authorization: Bearer AAEAAWVsYXN0aWMva2liYW5hL2tpYmFuYS10b2tlbjphQklUemJMWVJSNjYyVmVSR3NBZkhB" -k https://elasticsearch.lab.local:9200
```

Файлы:
- [filebeat.yml](https://github.com/ssvssssvss/-DDL-DML-/blob/final/file/filebeat.yml)

Скриншоты:

Успешный тест Elacticsearch:

![elasticsearch test](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr21_elastic_status.PNG)

Успешный запуск filebeat:

![filebeat status](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/src19_filebeat_status.PNG)

Логи nginx

![nginx logs](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/src20_elastic.PNG)

5. Kibana:
- Запущен через Docker:

```bash
docker run -d \
 --name kibana \
 -p 5601:5601 \
 -e ELASTICSEARCH_HOSTS="https://10.10.3.36:9200" \
 -e ELASTICSEARCH_SERVICEACCOUNTTOKEN="elasticsearch_token" \
 -e ELASTICSEARCH_SSL_VERIFICATIONMODE=none \
 docker.elastic.co/kibana/kibana:8.11.0
```

6. Сеть:
- Приватные подсети:
  -- web
  -- elasticsearch
- Публичные:
  -- bastion
  -- zabbix
  -- kibana
  -- load balancer

Скриншоты:

Развернутый бастион-хост и успешное подключение к нему:

![bastion](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr6_ssh_bastion.PNG)

Подключение к серверам через bastion:

![jump host](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr9_jumphost.PNG)

Созданные подсети:

![subnets](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr3_subnets.PNG)

Демонстрация работы ELB:

![ELB](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr13_elb.PNG)

7. Резервное копирование:
- Созданы snapshot дисков всех ВМ,
- Настроена политика: ежедневно, хранение 7 дней.

Скриншоты:

Настроена политика ежедневного резервного копирования, хранение копии 7 дней:

![cron snapshot](https://github.com/ssvssssvss/-DDL-DML-/blob/final/img/scr22_snapshoot.PNG)

Итоги выполненной работы:
- отказоустойчивый веб-сервис (2 VM + LB)
- мониторинг (Zabbix),
- логирование (ELK),
- безопасная сеть (VPC + bastion),
- резервное копирование.
