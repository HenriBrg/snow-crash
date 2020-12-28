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

    level09@SnowCrash:~$ xxd token
    0000000: 6634 6b6d 6d36 707c 3d82 7f70 826e 8382  f4kmm6p|=..p.n..
    0000010: 4442 8344 757b 7f8c 890a                 DB.Du{....

    ptrace = puts("You should not reverse this"You should not reverse this

    Le binaire ne semble pas open en tant que fichier l'argument passé, simplement le manipule comme une chaine de caractère random

    level09@SnowCrash:~$ objdump -d level09 | awk -F"\n" -v RS="\n\n" '$1 ~ /<main>/' | grep call
        8048821:	e8 ba fc ff ff       	call   80484e0 <ptrace@plt>        --> ?              
        8048831:	e8 4a fc ff ff       	call   8048480 <puts@plt>
        8048847:	e8 24 fc ff ff       	call   8048470 <getenv@plt>
        8048873:	e8 e8 fb ff ff       	call   8048460 <fwrite@plt>
        8048891:	e8 0a fc ff ff       	call   80484a0 <open@plt>
        80488bd:	e8 9e fb ff ff       	call   8048460 <fwrite@plt>
        80488db:	e8 c4 fc ff ff       	call   80485a4 <syscall_open>
        8048912:	e8 49 fb ff ff       	call   8048460 <fwrite@plt>
        8048930:	e8 96 fd ff ff       	call   80486cb <isLib>
        8048960:	e8 66 fd ff ff       	call   80486cb <isLib>
        8048991:	e8 2a fb ff ff       	call   80484c0 <putchar@plt>
        80489da:	e8 f1 fa ff ff       	call   80484d0 <fputc@plt>
        8048a07:	e8 54 fa ff ff       	call   8048460 <fwrite@plt>
        8048a1d:	e8 24 fc ff ff       	call   8048646 <afterSubstr>
        8048a49:	e8 12 fa ff ff       	call   8048460 <fwrite@plt>
        8048a68:	e8 67 fb ff ff       	call   80485d4 <syscall_gets>
        8048a87:	e8 c4 f9 ff ff       	call   8048450 <__stack_chk_fail@plt>

    level09@SnowCrash:~$ objdump -d level09 | awk -F"\n" -v RS="\n\n" '$1 ~ /<isLib>/' | grep call
        80486de:	e8 63 ff ff ff       	call   8048646 <afterSubstr>
    

    long ptrace(enum __ptrace_request request, pid_t pid, void *addr, void *data);
    The ptrace() system call provides a means by which one process
       (the "tracer") may observe and control the execution of another
       process (the "tracee"), and examine and change the tracee's
       memory and registers.  It is primarily used to implement
       breakpoint debugging and system call tracing.


    Pas de piste en particulier, essayons de capter ce que fais le programme en testant à fond
    
    level09@SnowCrash:~$ ./level09 A
        A
    level09@SnowCrash:~$ ./level09 AB
        AC
    level09@SnowCrash:~$ ./level09 ABC
        ACE
    level09@SnowCrash:~$ ./level09 ABCDEFGHIJKLMNOPQRSTUVWXYZ
        ACEGIKMOQSUWY[]_acegikmoqs

    ABCDEFGHIJKLMNOPQRSTUVWXYZ

    Il y a une sorte de décalage

    [... XX hours later]

    ./level09 .
    ./level09 .......... --> hmm ?

    ./level09 ........................................................................................................................
        ./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~��������������������������������������

    Il y a un décalagé proportionel à l'index du char dans le string

    ./level09 0123456789ABCDEFG
        02468:<>@BKMOQSUW
    
    Logique de décryption introuvable, on va partir de l'output pour essayer de capter

    level09@SnowCrash:~$ cat token  -----> f4kmm6p|=�p�n��DB�Du{��

    ./level09 f3        --> f4
    ./level09 f3        --> f4
    ./level09 f3i       --> f4k
    [...........]

    level09@SnowCrash:~$ hexdump -C token
    00000000  66 34 6b 6d 6d 36 70 7c  3d 82 7f 70 82 6e 83 82  |f4kmm6p|=..p.n..|
    00000010  44 42 83 44 75 7b 7f 8c  89 0a                    |DB.Du{....|
    0000001a

              66 34 6b 6d 6d 36 70 7c  3d
              f  4  k  m  m  6  p  |   = f3iji1ju5
              
              echo $((16#82)) ; echo $((16#7f)) ; echo $((70)) ; echo $((16#82)) ; echo $((16#6e)) ; echo $((16#83)) ; echo $((16#82))
              82 7f 70 82 6e 83 82        ------> ASCII 130 127 112 130 110 131 130 ---> 

            130 - 9         = 121 = y
            127 - 10        = 117 = u
            112  - 11       = 101 = e
            130             = 118 = v
            110             = 97  = a
            131             = 117 = u
            130 - 15        = 115 = s

            echo $((16#44)) ; echo $((16#42)) ; echo $((16#83)) ; echo $((16#44)) ; echo $((16#75)) ; echo $((16#7b)) ; echo $((16#7f)) ; echo $((16#8c)) ; echo $((16#89)) ; echo $((16#0a))
            44 42 83 44 75 7b 7f 8c  89  ------> ASCII 130 127 70 130 110 131 130 ---> 

            Le dernier '0a' c'est le line return

            68  - 16 = 52   = 4
            66  - 17 = 49   = 1
            131 - 18 = 113  = q
            68  - 19 = 49   = 1
            117 - 20 = 97   = a
            123 - 21 = 102  = f
            127 - 22 = 105  = i
            140 - 23 = 117  = u
            137 - 24 = 113  = q
        
    Total  f3iji1ju5yuevaus41q1afiuq

    su flag09 f3iji1ju5yuevaus41q1afiuq
    getflag

    NB : cf. script python pour reverse

* Solution

------------------------------------------------------------------------------------------------------------------------

