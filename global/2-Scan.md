Starting Nmap 7.91 ( https://nmap.org ) at 2020-12-19 22:35 CET
Nmap scan report for 192.168.99.142
Host is up (0.00048s latency).
Not shown: 65531 closed ports
PORT     STATE SERVICE VERSION
80/tcp   open  http    Apache httpd 2.2.22 ((Ubuntu))
|_http-server-header: Apache/2.2.22 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
4242/tcp open  ssh     OpenSSH 5.9p1 Debian 5ubuntu1.7 (Ubuntu Linux; protocol 2.0)
|_dicom-ping: 
| ssh-hostkey: 
|   1024 3f:48:94:21:d7:48:1a:90:45:70:5a:9b:49:b1:d4:22 (DSA)
|   2048 30:c7:4d:19:15:6d:f0:33:a6:04:cd:00:e1:f9:a3:6c (RSA)
|_  256 6a:83:c6:2e:df:7a:c8:e0:1c:bc:d8:84:32:e0:84:ad (ECDSA)
4646/tcp open  http    Apache httpd 2.2.22 ((Ubuntu))
|_http-server-header: Apache/2.2.22 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
4747/tcp open  http    Apache httpd 2.2.22 ((Ubuntu))
|_http-server-header: Apache/2.2.22 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
MAC Address: 08:00:27:BA:8F:93 (Oracle VirtualBox virtual NIC)
Device type: general purpose
Running: Linux 3.X
OS CPE: cpe:/o:linux:linux_kernel:3
OS details: Linux 3.2 - 3.16
Network Distance: 1 hop
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE
HOP RTT     ADDRESS
1   0.48 ms 192.168.99.142

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.66 seconds
