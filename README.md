Домашнее задание по лекции "Работа с данными (DDL/DML)". Грекова Иоланта.

**Задание 1**
1.1. Поднимите чистый инстанс MySQL версии 8.0+. Можно использовать локальный сервер или контейнер Docker.
1.2. Создайте учётную запись sys_temp.
1.3. Выполните запрос на получение списка пользователей в базе данных. (скриншот)
1.4. Дайте все права для пользователя sys_temp.
1.5. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)
1.6. Переподключитесь к базе данных от имени sys_temp.
Для смены типа аутентификации с sha2 используйте запрос:
ALTER USER 'sys_test'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
1.6. По ссылке https://downloads.mysql.com/docs/sakila-db.zip скачайте дамп базы данных.
1.7. Восстановите дамп в базу данных.
1.8. При работе в IDE сформируйте ER-диаграмму получившейся базы данных. При работе в командной строке используйте команду для получения всех таблиц базы данных. (скриншот)
Результатом работы должны быть скриншоты обозначенных заданий, а также простыня со всеми запросами.

**Ответ**
1.3.
![Скриншот запроса на получение списка пользователей в БД](https://github.com/ssvssssvss/-DDL-DML-/blob/DB/systeml.PNG)

1.5.
![Скриншотн запроса на получение списка прав для пользотеля](https://github.com/ssvssssvss/-DDL-DML-/blob/DB/systemp_grants.PNG)

1.8.
![Таблицы БД](https://github.com/ssvssssvss/-DDL-DML-/blob/DB/db.PNG)


---
```bash
# Пункт 1.1 — Поднятие инстанса MySQL (локальная установка)
sudo apt-get update
sudo apt-get install mysql-server -y
sudo systemctl start mysql
sudo mysql
```
```sql
# Пункт 1.2 — Создание учетной записи sys_temp
CREATE USER 'sys_temp'@'localhost' IDENTIFIED BY 'password';
# Пункт 1.3 — Получение списка пользователей
SELECT user FROM mysql.user;
# Пункт 1.4 — Выдача всех прав пользователю sys_temp
GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'localhost';
# Пункт 1.5 — Получение списка прав для sys_temp
SHOW GRANTS FOR 'sys_temp'@'localhost';
# Пункт 1.6 — Смена типа аутентификации и переподключение
ALTER USER 'sys_temp'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
EXIT;
```
```bash
mysql -u sys_temp -p
#Пункт 1.6 (скачивание дампа) — выполнялось в терминале ОС
wget https://downloads.mysql.com/docs/sakila-db.zip
unzip sakila-db.zip
```
```sql
# Пункт 1.7 — Восстановление дампа
SOURCE /home/vboxuser/sakila-db/sakila-schema.sql;
SOURCE /home/vboxuser/sakila-db/sakila-data.sql;
# Пункт 1.8 — Получение списка таблиц
SHOW DATABASES;
USE sakila;
SHOW TABLES;
```

**Задание 2**
Составьте таблицу, используя любой текстовый редактор или Excel, в которой должно быть два столбца: в первом должны быть названия таблиц восстановленной базы, во втором названия первичных ключей этих таблиц. Пример: (скриншот/текст)

**Ответ**
markdown

| Таблица | Первичный ключ |
|---------|---------------|
| actor | actor_id |
| address | address_id |
| category | category_id |
| city | city_id |
| country | country_id |
| customer | customer_id |
| film | film_id |
| film_actor | actor_id, film_id |
| film_category | film_id, category_id |
| film_text | film_id |
| inventory | inventory_id |
| language | language_id |
| payment | payment_id |
| rental | rental_id |
| staff | staff_id |
| store | store_id |
