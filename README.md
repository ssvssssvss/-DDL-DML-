Домашнее задание к занятию «Уязвимости и атаки на информационные системы». Грекова Иоланта 

**Задание 1**
*Скачайте и установите виртуальную машину Metasploitable: https://sourceforge.net/projects/metasploitable/.*

*Это типовая ОС для экспериментов в области информационной безопасности, с которой следует начать при анализе уязвимостей.*

*Просканируйте эту виртуальную машину, используя nmap.*

*Попробуйте найти уязвимости, которым подвержена эта виртуальная машина.*

*Сами уязвимости можно поискать на сайте https://www.exploit-db.com/.*

*Для этого нужно в поиске ввести название сетевой службы, обнаруженной на атакуемой машине, и выбрать подходящие по версии уязвимости.*

**Ответ:**

*Какие сетевые службы в ней разрешены?*

PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         vsftpd 2.3.4
22/tcp   open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
23/tcp   open  telnet      Linux telnetd
25/tcp   open  smtp        Postfix smtpd
53/tcp   open  domain      ISC BIND 9.4.2
80/tcp   open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
111/tcp  open  rpcbind     2 (RPC #100000)
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
512/tcp  open  exec        netkit-rsh rexecd
513/tcp  open  login       OpenBSD or Solaris rlogind
514/tcp  open  tcpwrapped
1099/tcp open  java-rmi    GNU Classpath grmiregistry
1524/tcp open  bindshell   Metasploitable root shell
2049/tcp open  nfs         2-4 (RPC #100003)
2121/tcp open  ftp         ProFTPD 1.3.1
3306/tcp open  mysql       MySQL 5.0.51a-3ubuntu5
5432/tcp open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
5900/tcp open  vnc         VNC (protocol 3.3): уязвимость Vino VNC Server 3.7.3 - Persistent Denial of Service DoS
6000/tcp open  X11         (access denied)
6667/tcp open  irc         UnrealIRCd
8009/tcp open  ajp13       Apache Jserv (Protocol v1.3)
8180/tcp open  http        Apache Tomcat/Coyote JSP engine 1.1
MAC Address: 08:00:27:0D:83:44 (Oracle VirtualBox virtual NIC)
Service Info: Hosts:  metasploitable.localdomain, irc.Metasploitable.LAN; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel


*Какие уязвимости были вами обнаружены? (список со ссылками: достаточно трёх уязвимостей)*
rpcbind: 
RPCBind / libtirpc - Denial of Service: https://www.exploit-db.com/exploits/41974
rpcbind - CALLIT procedure UDP Crash (PoC): https://www.exploit-db.com/exploits/26887

postgresql:
PostgreSQL 8.3.6 - Conversion Encoding Remote Denial of Service: https://www.exploit-db.com/exploits/32849
PostgreSQL 8.2/8.3/8.4 - UDF for Command Execution: https://www.exploit-db.com/exploits/7855

vnc: Vino VNC Server 3.7.3 - Persistent Denial of Service: https://www.exploit-db.com/exploits/28338

irc: 
UnrealIRCd 3.2.8.1 - Backdoor Command Execution (Metasploit): https://www.exploit-db.com/exploits/16922
UnrealIRCd 3.2.8.1 - Remote Downloader/Execute: https://www.exploit-db.com/exploits/13853

**Задание 2**
*Проведите сканирование Metasploitable в режимах SYN, FIN, Xmas, UDP.*

*Запишите сеансы сканирования в Wireshark.*

*Ответьте на следующие вопросы:*

**Ответы**
*Чем отличаются эти режимы сканирования с точки зрения сетевого трафика?*
Различные режимы сканирования отличаются типами отправляемых пакетов и реакцией целевой системы.
Различия между режимами сканирования заключаются в используемых типах пакетов и способах интерпретации ответа: наличие ответа (SYN-ACK, RST, ICMP) или его отсутствие.

*Как отвечает сервер?*
UDP-сканирование отправляет UDP-пакеты. Закрытые порты отвечают ICMP-сообщением «Destination Unreachable (Port Unreachable)», а открытые порты не отвечают.
Xmas-сканирование использует TCP-пакеты с флагами FIN, PSH и URG. Поведение аналогично FIN: открытые порты не отвечают, закрытые отправляют RST.
FIN-сканирование отправляет TCP-пакеты с флагом FIN. Открытые порты игнорируют такие пакеты, а закрытые отвечают RST.
SYN-сканирование использует TCP-пакеты с флагом SYN. Открытые порты отвечают SYN-ACK, после чего сканер отправляет RST, не завершая соединение. Закрытые порты отвечают RST.
