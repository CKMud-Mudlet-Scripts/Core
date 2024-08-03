Settings = Settings or {}
if matches[2] then
  Settings.config_attack = matches[2]
  echo("Set Attack Config to " .. Settings.config_attack .. "\n")
else
  echo("configure is " .. Settings.config_attack .. "\n")
end