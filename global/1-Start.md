* Introduction

--------------------------------------------------------------------------------------------------------------------------------------------------------

* Entrée

    ssh level00@192.168.99.142 -p 4242
        level00
    chmod u+w .bashrc ; echo 'alias c="clear"' >> ~/.bashrc ; source .bashrc
    
    • Find ALL SUID Files : find . -perm /u=s,g=s


* Scan du réseau avec nmap : sudo nmap -sV -O -A 192.168.99.142 -p-

    80/tcp   open  http    Apache
    4242/tcp open  ssh     OpenSSH
    4646/tcp open  http    Apache
    4747/tcp open  http    Apache

* Intéressant

    **Level 04**
        
        ls -la /var/www                                 --> Contenu / Description : potentiellement des ressources à manipuler via le serveur HTTP
        cat log/apache2/suexec.log                      


    **Level 05**

        ls -la /var/mail                                --> Contenu / Description : */2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05
        cat /etc/apache2/sites-enabled/level05.conf
        cat /var/mail/level05                         
        /etc/apache2/sites-available
        cat /etc/apache2/ports.conf

    **Level 12**

    ls -la /var/www                                     --> Contenu / Description : potentiellement des ressources à manipuler via le serveur HTTP
    cat log/apache2/suexec.log                          --> Failles suExec

* ALL Levels


    L'URL http://192.168.99.142/cgi-bin/ renvoie un 403
    cat /etc/apache2/sites-available/default

    cat /var/log/apache2/suexec.log                     --> Contenu / Description : potentiellement des CGI en Perl
    cat /var/log/apache2/access.log                     --> Contenu / Description : Tous les LOG du serveur Apache


    find . -perm -u=x                                   --> Find ALL Files where permissions for user is 'x'

---------------------------------------------------------------------------------------------------------------------------------------------------------

* Utilitaires

export nomDeLaFaille="level01" ; mkdir $nomDeLaFaille ; mkdir $nomDeLaFaille/ressources ; touch $nomDeLaFaille/ressources/Main.md $nomDeLaFaille flag
VBoxManage startvm "snowcrash" --type headless
VBoxManage controlvm "snowcrash" poweroff soft
