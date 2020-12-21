LEVEL 02

------------------------------------------------------------------------------------------------------------------------

scp -P 4242 level02@192.168.99.142:/home/user/level02/level02.pcap $(pwd)

* Solution

    Follow le stream TCP
    Itérer sur les modes d'affichage des données, jusqu'à UTF8

    En UTF8, on obtient

        Linux 2.6.38-8-generic-pae (::ffff:10.1.1.2) (pts/10)
        Password: ft_wandrNDRelL0L
        Login incorrect
        wwwbugs login: 

    su flag02 ft_wandrNDRelL0L
    getflag
    su level03 kooda2puivaav1idi4f57q8iq
    
------------------------------------------------------------------------------------------------------------------------
