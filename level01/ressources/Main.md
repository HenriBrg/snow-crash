LEVEL 01

------------------------------------------------------------------------------------------------------------------------

find . -group flag01            -> RAS
find . -perm /u=s,g=s           -> RAS

* Solution

        cat /etc/passwd         -> flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
        Dans l'idée, on peut faire un tour ici : https://www.tunnelsup.com/hash-analyzer/ même si ça ne ressemble pas à un hash, ça semble être du DES
        On peut tenter avec JtR
        echo flag01:42hDRfypTqqnw > tmp.txt
        john tmp.txt 
        Success : 1 password hash cracked, 0 left
        42hDRfypTqqnw -> abcdefg
        su flag01 abcdefg

        su level02 f2av5il02puano7naaf6adaaf

------------------------------------------------------------------------------------------------------------------------

NB : Good Intro to JtR : https://linuxconfig.org/password-cracking-with-john-the-ripper-on-linux