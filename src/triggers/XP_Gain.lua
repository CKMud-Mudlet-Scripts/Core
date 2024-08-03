local multi = tonumber(matches[2])
local inc = tonumber(string.trim(string.gsub(matches[3], ",", "")))
local adj_inc = inc / multi
xp_count = xp_count or 0
total = total or 0
total = total + adj_inc
xp_count = xp_count + 1
echoc("[<cyan>" .. adj_inc .. "<white>]")
--[1.5x][Pl +156]
Times.lastxpgain = getEpoch()