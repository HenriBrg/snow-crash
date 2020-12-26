LEVEL 09

------------------------------------------------------------------------------------------------------------------------

    find . -user level09 2> /dev/null | grep -v proc
                 flag09
    find . -perm /u=s,g=s 2> /dev/null | grep -v proc
    find . -type f -user flag09 -o -user level09
    find . -maxdepth 1 -name "*string*" -print


* Recherches


    strings level09

        You should not reverse this
        LD_PRELOAD
        Injection Linked lib detected exit..
      
        You need to provied only one arg.
        00000000 00:00 0
        ;*2$"$

    level09@SnowCrash:~$ hd -c token
    00000000  66 34 6b 6d 6d 36 70 7c  3d 82 7f 70 82 6e 83 82  |f4kmm6p|=..p.n..|
    0000000   f   4   k   m   m   6   p                         |   = 202 177   p 202   n 203 202
    00000010  44 42 83 44 75 7b 7f 8c  89 0a                    |DB.Du{....|
    0000010   D   B 203   D   u   { 177 214 211  \n
    000001a

* Solution



------------------------------------------------------------------------------------------------------------------------