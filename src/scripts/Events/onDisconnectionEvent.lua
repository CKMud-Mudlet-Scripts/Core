function onDisconnectionEvent(eventname)
Toggles.firstprompt = false
end

function is_connected()
return Toggles.firstprompt == true 
end