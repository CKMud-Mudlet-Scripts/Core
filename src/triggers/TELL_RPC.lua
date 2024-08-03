--[[
This is a rpc think irc bot we dispatch to `TELL RPC` Script
]]

local who = matches[2]
local what = matches[3]
if string.starts(what, "!") and FRIED_read_toggle("tell_rpc") then
  handle_tell_rpc(who, what)
end