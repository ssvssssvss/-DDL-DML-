Домашнее задание к занятию 2 «Кластеризация и балансировка нагрузки». Грекова Иоланта.

**Задание 1**
Запустите два simple python сервера на своей виртуальной машине на разных портах
Установите и настройте HAProxy, воспользуйтесь материалами к лекции по ссылке
Настройте балансировку Round-robin на 4 уровне.
На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.

**Ответ**
```bash
cat /etc/haproxy/haproxy.cfg
```
```cfg
global
   log /dev/log local0
   maxconn 1000

defaults
   mode tcp
   timeout connect 5s
   timeout client  50s
   timeout server  50s

frontend my_front
   bind *:9000
   default_backend my_back

backend my_back
   balance roundrobin
   server s1 127.0.0.1:8001 check
   server s2 127.0.0.1:8002 chec
```
![]()
![]()
![]()

**Задание 2**
Запустите три simple python сервера на своей виртуальной машине на разных портах
Настройте балансировку Weighted Round Robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4
HAproxy должен балансировать только тот http-трафик, который адресован домену example.local
На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.

**Ответ**
```bash
cat /etc/haproxy/haproxy.cfg
```
```cfg
global
   log /dev/log local0
   maxconn 1000

defaults
   mode http
   timeout connect 5s
   timeout client  50s
   timeout server  50s

frontend http_front
   bind *:9000
   acl is_example hdr(host) -i example.local
   use_backend weighted_back if is_example
   default_backend deny_back

backend weighted_back
   balance roundrobin
   server s1 127.0.0.1:8001 weight 2 check
   server s2 127.0.0.1:8002 weight 3 check
   server s3 127.0.0.1:8003 weight 4 check

backend deny_back
   http-request deny
```
![]()
