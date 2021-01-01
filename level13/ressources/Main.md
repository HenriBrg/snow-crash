LEVEL 13

------------------------------------------------------------------------------------------------------------------------

    find . -user level13 2> /dev/null | grep -v proc
                 flag13
    find . -perm /u=s,g=s 2> /dev/null | grep -v proc
    find . -type f -user flag13 -o -user level13
    
* Recherches


    strings level13

        UID %d started us but we we expect %d
        boe]!ai0FB@.:|L6l@A?>qJ}I
        your token is %s

    file level13
    ldd level13

    objdump -d level13 | awk -F"\n" -v RS="\n\n" '$1 ~ /<main>/' | grep call

    objdump -d level13 | awk -F"\n" -v RS="\n\n" '$1 ~ /<ft_des>/' | grep call

    strace / ltrace



* Infos

------------------------------------------------------------------------------------------------------------------------

Assembleur : Function main is a normal function with its args in rdi, rsi, following the normal calling convention. 