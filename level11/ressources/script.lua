#!/usr/bin/env lua
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 5151))

function hash(pass)
  prog = io.popen("echo -n "..pass.." | shasum", "r") -- Potentiellement pb ici
  data = prog:read("*all")                    
  prog:close()

  print(" [-] Pass = " .. pass)                    --  Added
  print(" [-] Data = " .. data)                    --  Added

  data = string.sub(data, 1, 40)              -- --> http://www.luteus.biz/Download/LoriotPro_Doc/LUA/LUA_Training_FR/LUA_Fonction_Chaine.html - tout en bas --> 0, 40 ?
  
  print(" [+] Pass = " .. pass)                    --  Added
  print(" [+] Data = " .. data)                    --  Added

  return data
end

while 1 do
  local client = server:accept()
  client:send("Password: ")
  client:settimeout(60)
  local l, err = client:receive()
  if not err then
      print("trying " .. l)


      print(" [-] Before hash() : l = " .. l)                    --  Added

      local h = hash(l)

      print(" [-] After  hash() : return = " .. h)                    --  Added



      if h ~= "f05d1d066fb246efe0c6f7d095f909a7a0cf34a0" then -- The ~= is not equals. It is the equivalent in other languages of !=
          client:send("Erf nope..\n");
      else
          client:send("Gz you dumb*\n")
      end
  end
  client:close()
end