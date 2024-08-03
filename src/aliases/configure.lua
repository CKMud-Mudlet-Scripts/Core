if matches[2] then
  Settings = Settings or {}
  Settings.config_attack = matches[2]
  echo("Set Configure to " .. Settings.config_attack .. "\n")
end
send(matches[1], false)