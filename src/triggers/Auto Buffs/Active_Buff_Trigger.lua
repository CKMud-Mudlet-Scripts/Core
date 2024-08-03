if PromptFlags.affections then
-- okay we are looking at status
  local affect = string.trim(matches.affect)
  local timeleft = (tonumber(string.trim(matches.time)) or 1) * 60
  echoc("<green> "..timeleft.." seconds")
  PromptFlags.affects[affect] = true
end