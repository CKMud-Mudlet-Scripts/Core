if PromptFlags.scorecard then
  local base = tonumber(string.trim(string.gsub(matches[3], ",", "")))
  local cur = tonumber(string.trim(string.gsub(matches[4], ",", "")))
  if matches[2] == "Strength" then
    Player.Stats.STR = cur
    Player.BaseStats.STR = base
    Player.Stats.SPD = tonumber(string.trim(string.gsub(matches[7], ",", "")))
    Player.BaseStats.SPD = tonumber(string.trim(string.gsub(matches[6], ",", "")))
  elseif matches[2] == "Wisdom" then
    Player.Stats.WIS = cur
    Player.BaseStats.WIS = base
    Player.UBS = tonumber(matches[5])
  elseif matches[2] == "Intellect" then
    Player.Stats.INT = cur
    Player.BaseStats.INT = base
    Player.LBS = tonumber(matches[5])
  end
end