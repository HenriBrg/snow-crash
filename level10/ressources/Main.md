LEVEL 10

------------------------------------------------------------------------------------------------------------------------

    find . -user level09 2> /dev/null | grep -v proc
                 flag09
    find . -perm /u=s,g=s 2> /dev/null | grep -v proc
    find . -type f -user flag09 -o -user level09
    find . -maxdepth 1 -name "*string*" -print

* Recherches


    strace ./level10

        write(1, "./level10 file host\n\tsends file "..., 65./level10 file host
            sends file to host if you have access to it
        ) = 65


    strings ./level10

        %s file host                                            ---> utile
        sends file to host if you have access to it
        Connecting to %s:6969 ..                                ---> utile
        Unable to connect to host %s
        .*( )*.
        Unable to write banner to host %s
        Connected!
        Sending file ..
        Damn. Unable to open file
        Unable to read from file: %s
        wrote file!
        You don't have access to %s

    objdump -d level10 | awk -F"\n" -v RS="\n\n" '$1 ~ /<main>/' | grep call

    804870e:	e8 0d fe ff ff       	call   8048520 <printf@plt>
    804871a:	e8 71 fe ff ff       	call   8048590 <exit@plt>
    8048749:	e8 92 fe ff ff       	call   80485e0 <access@plt>
    8048766:	e8 b5 fd ff ff       	call   8048520 <printf@plt>
    8048773:	e8 b8 fd ff ff       	call   8048530 <fflush@plt>
    804878f:	e8 5c fe ff ff       	call   80485f0 <socket@plt>
    80487cb:	e8 30 fe ff ff       	call   8048600 <inet_addr@plt>
    80487de:	e8 6d fd ff ff       	call   8048550 <htons@plt>
    8048805:	e8 06 fe ff ff       	call   8048610 <connect@plt>
    804881f:	e8 fc fc ff ff       	call   8048520 <printf@plt>
    804882b:	e8 60 fd ff ff       	call   8048590 <exit@plt>
    8048847:	e8 74 fd ff ff       	call   80485c0 <write@plt>          --> Ici que le token peut passer
    8048861:	e8 ba fc ff ff       	call   8048520 <printf@plt>
    804886d:	e8 1e fd ff ff       	call   8048590 <exit@plt>
    804887a:	e8 a1 fc ff ff       	call   8048520 <printf@plt>
    8048887:	e8 a4 fc ff ff       	call   8048530 <fflush@plt>
    804889b:	e8 00 fd ff ff       	call   80485a0 <open@plt>
    80488b2:	e8 a9 fc ff ff       	call   8048560 <puts@plt>
    80488be:	e8 cd fc ff ff       	call   8048590 <exit@plt>
    80488da:	e8 31 fc ff ff       	call   8048510 <read@plt>
    80488ea:	e8 e1 fc ff ff       	call   80485d0 <__errno_location@plt>
    80488f4:	e8 77 fc ff ff       	call   8048570 <strerror@plt>
    8048905:	e8 16 fc ff ff       	call   8048520 <printf@plt>
    8048911:	e8 7a fc ff ff       	call   8048590 <exit@plt>
    804892d:	e8 8e fc ff ff       	call   80485c0 <write@plt>          --> Ici que le token peut passer
    8048939:	e8 22 fc ff ff       	call   8048560 <puts@plt>
    8048950:	e8 cb fb ff ff       	call   8048520 <printf@plt>
    8048965:	e8 d6 fb ff ff       	call   8048540 <__stack_chk_fail@plt>

    1er constat : connect port 6969 de l'hote donné en string (second arg)

    fflush : fflush() is typically used for output stream only. Its purpose is to clear (or flush) the output buffer and move
    the buffered data to console (in case of stdout) or disk (in case of file output stream). Below is its syntax.
    
    
    echo Hello > /tmp/x
    ./level10 /tmp/x 127.0.0.1
        Connecting to 127.0.0.1:6969 .. Unable to connect to host 127.0.0.1
    

    Inside VM : 

        ! Setup VM Bridge & Promiscous ALL
        python -m SimpleHTTPServer 6969
        Wireshark en0 + Filtre ip.src == ipvm
        ./level10 /tmp/x 192.168.1.23


    Inside Host : 
        ifconfig

    


* Solution

------------------------------------------------------------------------------------------------------------------------

