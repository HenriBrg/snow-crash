#!/usr/bin/env lua
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 5151))

function hash(pass)
  prog = io.popen("echo "..pass.." | shasum", "r")
  data = prog:read("*all")                    -- Potentiellement une faille ici je suppose
  prog:close()
  print("BEFORE Data = " .. data)             --  Added
  data = string.sub(data, 1, 40)              -- --> http://www.luteus.biz/Download/LoriotPro_Doc/LUA/LUA_Training_FR/LUA_Fonction_Chaine.html - tout en bas
  print("AFTER  Data = " .. data)             --  Added
  return data
end

while 1 do
  local client = server:accept()
  client:send("Password: ")
  client:settimeout(60)
  local l, err = client:receive()
  if not err then
      print("trying " .. l)
      local h = hash(l)
      if h ~= "f05d1d066fb246efe0c6f7d095f909a7a0cf34a0" then
          client:send("Erf nope..\n");
      else
          client:send("Gz you dumb*\n")
      end
  end
  client:close()
end