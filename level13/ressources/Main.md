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
        --> Il y a du récursif visiblement

    strace / ltrace --> Rien de très utile

    Aucun sens d'avoir un uid 4242, pas d'user de ce type trouvé dans les recherchés (oubliées de les noter ici)
    Pas vrmt de piste, donc à défaut on va essayer d'étudier le binaire direct dans gdb

    gdb ./level13

        disass main

            En fait, on voit une valeur hardcodé dans la comparaison avec l'uid 4242

        b main
        ni (autant de fois que nécessaire)

            Btw, on voit que le ret de getuid est bien le notre (logique) mais donc on devrait pour jouer sur la valeur du registre qui stock les ret, donc r/e ax

        x/i $pc -> voir la prochaine instruction

            (gdb) x/i $pc
            => 0x804859a <main+14>:	cmp    $0x1092,%eax
        
        On modifie la valeur de eax

            set $eax=0x1092 (4242 en hexa)

        c (continue)

        Et voici
        your token is 2A31L79asukciNyi8uppkEuSx

        su level14 2A31L79asukciNyi8uppkEuSx



* Infos

------------------------------------------------------------------------------------------------------------------------

Assembleur : Function main is a normal function with its args in rdi, rsi, following the normal calling convention. 