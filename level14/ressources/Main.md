LEVEL 14 - The Boss

------------------------------------------------------------------------------------------------------------------------

* Recherches

    OK, je sais que sur ce level on a aucun indice de départ
    Donc j'en profite pour suivre des tutos d'analyse complète de machine, un peu + realiste que des faille regex ^^'
    
    PE : https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Linux%20-%20Privilege%20Escalation.md#sensitive-files

    Longgg chemin (cf. cours pentest sur Notions) Rien trouvé, donc on peut voir direct du côté du binaire /get/flag

    CF. Explication Assembleur : disassGetFlag.s

    En manipulant les registres (btw, à demander feedback aux correcteurs si c'est tjrs free de manipuler les registres, ça parait surprenant, idem level13)

    gdb /bin/getflag
    b main
        ni (autant que nécessaire)
        ni 10
        x/i $pc (check current command)
        info rs

    ni
    1er stop : ptrace qui nous fait sortir car il ret -1, on modifie eax avant le jump
    set $eax=0x0 

    ni jusqu'à getuid
    ou alors : b getuid (on va jump DANS getuid)

    x/i $pc
    info r
    set $eax=3014 ou 0XBC6
    c

    Continuing.
    Check flag.Here is your token : 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ
    [Inferior 1 (process 2656) exited normally]
    
    su flag14 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ

    getflag

    Si j'avais vu ça plus tôt ... ^^'

