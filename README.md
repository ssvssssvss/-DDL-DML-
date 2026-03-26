Домашнее задание к занятию «Docker. Часть 2». Грекова Иоланта.

**Задание 1**
Напишите ответ в свободной форме, не больше одного абзаца текста.
Установите Docker Compose и опишите, для чего он нужен и как может улучшить лично вашу жизнь.

**Ответ**
Docker Compose —  инструмент для оркестрации многоконтейнерных приложений, который дает возможность с помощью одной команды (`docker-compose up`) и YAML-файла описывать, запускать и связывать все необходимые сервисы.
- Не нужно вручную прописывать `docker run` команды с параметрами сетей и томов для каждого контейнера. 
- Лично мне он улучшает жизнь тем, что решает проблему «а у меня не запускается» у команды и менеджеров проекта.
- Конфигурация всей инфраструктуры проекта хранится в одном файле, обеспечивая полную идентичность окружения на любой машине.
- Экономит часы времени, так как больше не нужно вспоминать, с какими флагами поднимать PostgreSQL или Redis.

**Задание 2**
Выполните действия и приложите текст конфига на этом этапе.
Создайте файл docker-compose.yml и внесите туда первичные настройки:
version;
services;
volumes;
networks.
При выполнении задания используйте подсеть 10.5.0.0/16. Ваша подсеть должна называться: <ваши фамилия и инициалы>-my-netology-hw. Все приложения из последующих заданий должны находиться в этой конфигурации.

**Ответ**
```yml
version: '3.8'

services: {}

volumes: {}

networks:
  grekovais-my-netology-hw:
    driver: bridge
    ipam:
      config:
        - subnet: 10.5.0.0/16
```

**Задание 3**
Выполните действия:
Создайте конфигурацию docker-compose для Prometheus с именем контейнера <ваши фамилия и инициалы>-netology-prometheus.
Добавьте необходимые тома с данными и конфигурацией (конфигурация лежит в репозитории в директории 6-04/prometheus ).
Обеспечьте внешний доступ к порту 9090 c докер-сервера.

**Ответ**
Внесены изменения в yml файл, добавлен сервис:
```yml
services:
  prometheus:
    container_name: grekovais-netology-prometheus
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus:/etc/prometheus
      - prometheus_data:/prometheus
    networks:
      - grekovais-my-netology-hw
```

**Задание 4**
Выполните действия:
Создайте конфигурацию docker-compose для Pushgateway с именем контейнера <ваши фамилия и инициалы>-netology-pushgateway.
Обеспечьте внешний доступ к порту 9091 c докер-сервера.

**Ответ**
Добавлен еще один сервис:
```yml
pushgateway:
    container_name: grekovais-netology-pushgateway
    image: prom/pushgateway:latest
    ports:
      - "9091:9091"
    networks:
      - grekovais-my-netology-hw
```

**Задание 5**
Выполните действия:
Создайте конфигурацию docker-compose для Grafana с именем контейнера <ваши фамилия и инициалы>-netology-grafana.
Добавьте необходимые тома с данными и конфигурацией (конфигурация лежит в репозитории в директории 6-04/grafana.
Добавьте переменную окружения с путем до файла с кастомными настройками (должен быть в томе), в самом файле пропишите логин=<ваши фамилия и инициалы> пароль=netology.
Обеспечьте внешний доступ к порту 3000 c порта 80 докер-сервера.

**Ответ**
Добавлена конфигурация для grafana + сервис:
```bash
nano ~/docker-hw/grafana/grafana.ini
```

**Задание 6**
Выполните действия.
Настройте поочередность запуска контейнеров.
Настройте режимы перезапуска для контейнеров.
Настройте использование контейнерами одной сети.
Запустите сценарий в detached режиме.

**Ответ**
Внесены необходимые изменения в yml файл.

**Задание 7**
Выполните запрос в Pushgateway для помещения метрики <ваши фамилия и инициалы> со значением 5 в Prometheus: echo "<ваши фамилия и инициалы> 5" | curl --data-binary @- http://localhost:9091/metrics/job/netology.
Залогиньтесь в Grafana с помощью логина и пароля из предыдущего задания.
Cоздайте Data Source Prometheus (Home -> Connections -> Data sources -> Add data source -> Prometheus -> указать "Prometheus server URL = http://prometheus:9090" -> Save & Test).
Создайте график на основе добавленной в пункте 5 метрики (Build a dashboard -> Add visualization -> Prometheus -> Select metric -> Metric explorer -> <ваши фамилия и инициалы -> Apply.
В качестве решения приложите:
docker-compose.yml целиком;
скриншот команды docker ps после запуске docker-compose.yml;
скриншот графика, постоенного на основе вашей метрики.

**Ответ**
```yml
# version: '3.8'
services:
 prometheus:
   container_name: grekovais-netology-prometheus
   image: prom/prometheus:latest
   ports:
     - "9090:9090"
   volumes:
     - ./prometheus:/etc/prometheus
     - prometheus_data:/prometheus
   networks:
     - grekovais-my-netology-hw

 pushgateway:
   container_name: grekovais-netology-pushgateway
   image: prom/pushgateway:latest
   restart: unless-stopped
   ports:
     - "9091:9091"
   networks:
     - grekovais-my-netology-hw

 grafana:
   container_name: grekovais-netology-grafana
   image: grafana/grafana:latest
   restart: unless-stopped
   ports:
     - "80:3000"
   volumes:
     - ./grafana:/etc/grafana
     - grafana_data:/var/lib/grafana
   environment:
     - GF_PATHS_CONFIG=/etc/grafana/grafana.ini
   networks:
     - grekovais-my-netology-hw
   depends_on:
     - prometheus
     - pushgateway

volumes:
 prometheus_data: {}
 grafana_data: {}

networks:
 grekovais-my-netology-hw:
   driver: bridge
   ipam:
     config:
       - subnet: 10.5.0.0/16
```

![docker ps](https://github.com/ssvssssvss/-DDL-DML-/blob/docker/task7_dockerps.PNG)
![grafana dashboard](https://github.com/ssvssssvss/-DDL-DML-/blob/docker/task7_grafana.PNG)

**Задание 8**
Выполните действия:
Остановите и удалите все контейнеры одной командой.
В качестве решения приложите скриншот консоли с проделанными действиями.

**Ответ**
![remove containers](https://github.com/ssvssssvss/-DDL-DML-/blob/docker/task8_remove.PNG)
