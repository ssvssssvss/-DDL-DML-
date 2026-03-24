Домашнее задание к занятию «Репликация и масштабирование. Часть 1». Грекова Иоланта.

**Задание 1**
На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.
Ответить в свободной форме.

**Ответ**
Master-Slave: 
- один сервер (master) обрабатывает все операции записи
- один или несколько slave получают изменения и могут использоваться для чтения.

Master-Master: 
- два сервера равноправны — оба могут выполнять записи и читать данные. 
- Изменения синхронизируются между ними, но требуется механизм разрешения конфликтов при одновременных изменениях.

**Задание 2**
Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.
Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.

**Ответ**
![Статус службы mysql](https://github.com/ssvssssvss/-DDL-DML-/blob/DB2/status.PNG)
![Status slave](https://github.com/ssvssssvss/-DDL-DML-/blob/DB2/slavestatus.PNG)
![Status master](https://github.com/ssvssssvss/-DDL-DML-/blob/DB2/masterstatus.PNG)
![Конфигурация master](https://github.com/ssvssssvss/-DDL-DML-/blob/DB2/master.PNG)
![Конфигурация slave](https://github.com/ssvssssvss/-DDL-DML-/blob/DB2/slave.PNG)
![Активные процессы](https://github.com/ssvssssvss/-DDL-DML-/blob/DB2/ps.PNG)
![Вывод БД master](https://github.com/ssvssssvss/-DDL-DML-/blob/DB2/infomaster.PNG)
![Вывод БД slave](https://github.com/ssvssssvss/-DDL-DML-/blob/DB2/infoslave.PNG)

