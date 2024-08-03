if PromptFlags.scouterself and Player.HEAT == 0 then
Player.MAXHEAT = tonumber(string.trim(string.gsub(matches[2], ",", "")))
end