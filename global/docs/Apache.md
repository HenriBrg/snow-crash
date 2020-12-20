• suExec

FR : 
    Apache suEXEC est une fonctionnalité du serveur Web Apache.
    Il permet aux utilisateurs d'exécuter l'interface de passerelle commune et les applications côté serveur incluent en tant qu'utilisateur différent.
    Normalement, tous les processus de serveur Web s'exécutent en tant qu'utilisateur de serveur Web par défaut.


English : 
    The suEXEC feature provides Apache users the ability to run CGI and SSI programs
    under user IDs different from the user ID of the calling web server. Normally,
    when a CGI or SSI program executes, it runs as the same user who is running the
    web server.
    Used properly, this feature can reduce considerably the security risks involved
    with allowing users to develop and run private CGI or SSI programs.

https://www.exploit-db.com/exploits/27397

On peut voir dans cat /var/log/apache2/error.log que suExec est activé et que la version d'Apache et la 2.2.22 avec PHP 5.3

    cat /etc/apache2/suexec/www-data
    ll /var/log/apache2/ --> www-data user group on suexec.log
