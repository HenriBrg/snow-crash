LEVEL 06

------------------------------------------------------------------------------------------------------------------------

    find . -user level06 2> /dev/null | grep -v proc
                 flag06
    find . -perm /u=s,g=s

* Recherches

    • strings ./level06

        /usr/bin/php
        /home/user/level06/level06.php
        On devine que ça équivaut au call de execv
    
    • objdump -d level06 | awk -F"\n" -v RS="\n\n" '$1 ~ /<main>/'
        
        call   8048430 <execve@plt>
    

    ./level06 /bin/getflag /bin/getflag

            You should not reverse this
            flag.Here is your token : You are root are you that dumb ?
            Nope there is no token here for you sorry. Try again :)

    cat level06.php

        #!/usr/bin/php
        <?php
        function y($m) { $m = preg_replace("/\./", " x ", $m); $m = preg_replace("/@/", " y", $m); return $m; }
        function x($y, $z) { $a = file_get_contents($y); $a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a); $a = preg_replace("/\[/", "(", $a); $a = preg_replace("/\]/", ")", $a); return $a; }
        $r = x($argv[1], $argv[2]); print $r;
        ?>

            preg_replace — Rechercher et remplacer par expression rationnelle standard
            preg_replace ( string|array $pattern , string|array $replacement , string|array $subject [, int $limit = -1 [, int &$count = null ]] ) : string|array|null
            Analyse subject pour trouver l'expression rationnelle pattern et remplace les résultats par replacement.

        Décomposition :
        
        Appel x() avec argv[1] et [2]

            Stock le contenu du fichier argv[2] 
            Remplace le contenu    


    Au fait, zappé ça : 
        strings /bin/getflag
    
     objdump -h level06 | grep debug

            Le binaire n'a pas été compilé avec le flag -g permettant d'utiliser gdb dessus
    
    • file level06
        
        level06: setuid ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24, BuildID[sha1]=0xaabebdcd979e47982e99fa318d1225e5249abea7, not stripped

    cho "/bin/getflag" > /tmp/tmp1; echo "getflag" > /tmp/tmp2 ; ./level06 /tmp/tmp1 /tmp/tmp2
        
        /bin/getflag

* Solution

------------------------------------------------------------------------------------------------------------------------

• GDB & SUID

If you run a setuid program under debugger, and you're not root, it will run as if was not setuid. Meaning it will execute under your id, not root. So while you can spawn a shell, it will use your credentials.
You can easily test it yourself by launching su under gdb and verify in another console that it is executed under your user account.
And if you launch the setuid program and then try to gdb attach to it, this will return 'permission denied' error.

Remember : If you run a setuid program under debugger, and you're not root, it will run as if was not setuid
To Check : run gdb and from another console run "w" to check under which user gdb is running


• Symbols Debug

gcc -g tells the compiler to store symbol table information in the executable. Among other things, this includes:
symbol names
type info for symbols
files and line numbers where the symbols came from
Debuggers use this information to output meaningful names for symbols and to associate instructions with particular lines in the source.