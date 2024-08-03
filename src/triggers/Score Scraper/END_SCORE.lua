local function dam(stat1, stat2, supreme, boosted)
  if supreme then
    boosted = true
  end
  supreme_multi = supreme and 7500 or 5000
  boost_multi = boosted and 750 or 500
  return
    math.floor(
      (stat1 * supreme_multi) +
      (stat2 * supreme_multi) +
      (Player.DAMROLL * boost_multi) +
      (Player.HITROLL * boost_multi) +
      (Player.MAXPL / 100)
    )
end

local function ki_dam(supreme, boosted)
  return dam(Player.Stats.INT, Player.Stats.WIS, supreme, boosted)
end

local function phy_dam(supreme, boosted)
  return dam(Player.Stats.STR, Player.Stats.SPD, supreme, boosted)
end

local function item_tier()
  -- Thanks Vorrac
  local base_pl = Player.BASEPL
  local tier = 0
  if base_pl >= 500000000 then
    tier = 6
  elseif base_pl >= 250000000 then
    tier = 5
  elseif base_pl >= 125000000 then
    tier = 4
  elseif base_pl >= 75000000 then
    tier = 3
  elseif base_pl >= 25000000 then
    tier = 2
  elseif base_pl >= 1000000 then
    tier = 1
  end
  return tier
end

if PromptFlags.scorecard then
  echo("\n")
  Player.KI_DAM = ki_dam()
  Player.PHY_DAM = phy_dam()
  echoc(
    string.format(
      '<dim_gray>PHY DAM<white>:         <yellow>%-18s<dim_gray>KI DAM<white>: <yellow>%s\n',
      reformatInt(Player.PHY_DAM),
      reformatInt(Player.KI_DAM)
    )
  )
  echoc(
    string.format(
      '<dim_gray>PHY DAM(B)<white>:      <yellow>%-18s<dim_gray>KI DAM(B)<white>: <yellow>%s\n',
      reformatInt(calc_phy_dam(false, true)),
      reformatInt(calc_ki_dam(false, true))
    )
  )
  echoc(
    string.format(
      '<dim_gray>PHY DAM(S)<white>:      <yellow>%-18s<dim_gray>KI DAM(S)<white>: <yellow>%s\n',
      reformatInt(calc_phy_dam(true)),
      reformatInt(calc_ki_dam(true))
    )
  )
  echoc(string.format('<dim_gray>Item Tier<white>: <green>%7s\n', item_tier()))
end