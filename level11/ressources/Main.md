
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


* Solution

------------------------------------------------------------------------------------------------------------------------
