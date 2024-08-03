--[[
This script breaks down all the attacks into a simulated average damage per round
working in each of the modifiers like bleed,daze,etc and uses that data + the cost
to determine which attack to pick
]]

local function make_melee(cost, dmg, is_ubs, cooldown, count, extra)
  local extra_dict = {}
  for _, k in ipairs(extra or {}) do
    extra_dict[k] = true
  end
  return {cost, dmg, is_ubs, cooldown or 1, count or 1, extra_dict}
end

local function make_energy(cost, dmg, cooldown, count, extra)
  local extra_dict = {}
  for _, k in ipairs(extra or {}) do
    extra_dict[k] = true
  end
  return {cost, dmg, nil, cooldown or 1, count or 1, extra_dict}
end

--[[
  fast - 20% no cooldown chance
  piercing - ignore 20% armor
  
  Use daze for stun
  and bleed for burn
]]
local Extras =
  FRIED_make_enum("Extras", {"knockdown", "bleed", "daze", "fast", "piercing", "fast30"})
-- % damage  * (1+([UBS or LBS] / 100) / 4)
local melee_attacks =
  {
    ["punch"] = make_melee(3, 0.125, true),
    ["kick"] = make_melee(3, 0.125, false),
    ["roundhouse"] = make_melee(4, 0.25, false, 2),
    ["sweep"] = make_melee(5, 0.25, false, 1, 1, {Extras.knockdown}),
    ["uppercut"] = make_melee(4, 0.25, true, 2),
    ["dynamitekick"] = make_melee(5, 0.60, false, 2),
    ["machpunch"] = make_melee(4, 0.30, true, 1, 1, {Extras.fast}),
    ["machkick"] = make_melee(4, 0.30, false, 1, 1, {Extras.fast}),
    ["heel"] = make_melee(6, 0.80, false, 2, 1, {Extras.daze}),
    ["braver"] = make_melee(6, 0.80, true, 2, 1, {Extras.bleed}),
    ["wolf"] = make_melee(6, 0.10, true, 2, 8),
    ["cyclone"] = make_melee(6, 0.40, false, 2, 3, {Extras.daze}),
    ["rage"] = make_melee(8, 0.50, true, 2, 4, {Extras.bleed}),
    ["dpunch"] = make_melee(8, 0.90, true, 2, 1, {Extras.daze}),
    ["justice"] = make_melee(12, 0.80, false, 2, 4, {Extras.piercing}),
    ["godfist"] = make_melee(12, 1.25, true, 2, 1, {Extras.piercing}),
    ["supergodfist"] = make_melee(12, 2.25, true, 2, 1, {Extras.piercing}),
  }
local energy_attacks =
  {
    ["kishot"] = make_energy(2, 0.2, 1, 1, {Extras.fast}),
    ["eyebeam"] = make_energy(3, 0.2, 1, 1, {Extras.fast30}),
    ["kame"] = make_energy(20, 0.35),
    ["kienzan"] = make_energy(30, 0.5),
    ["photon"] = make_energy(40, 0.55),
    ["superk"] = make_energy(50, 0.65),
    ["bigbang"] = make_energy(60, 0.65, 2, 4),
    ["makan"] = make_energy(60, 0.85, 2, 3),
    ["chou"] = make_energy(60, 0.60, 2, 4),
    ["disrupt"] = make_energy(100, 0.75, 1, 1, {Extras.daze}),
    ["sblast"] = make_energy(100, 0.75, 1, 1, {Extras.bleed}),
    ["superbb"] = make_energy(160, 0.8, 2, 4),
    ["warpk"] = make_energy(240, 0.75, 2, 3, {Extras.daze}),
    ["genki"] = make_energy(300, 1.25, 3, 4),
    ["finalk"] = make_energy(1000, 3.0, 2),
  }

local function attack_dpr(name, data)
  -- Boil down each attack into a single metric so we can sort them
  local adj_dmg
  local is_melee = data[3] ~= nil
  if is_melee then
    local phy_dam = calc_phy_dam(Player.Supreme[name], Player.Boosted[name]) * data[2]
    local body = Player.LBS
    if data[3] then
      body = Player.UBS
    end
    adj_dmg = phy_dam * (1 + (body / 400))
  else
    adj_dmg = calc_ki_dam(Player.Supreme[name], Player.Boosted[name]) * data[2]
    -- if is_melee
  end
  local avg_cooldown = data[4]
  local avg_count = (data[5] + 1) / 2
  local extra = data[6]
  if extra[Extras.fast] then
    avg_cooldown = (data[4] + (data[4] - data[4] * 0.2)) / 2
  end
  if extra[Extras.fast30] then
    avg_cooldown = (data[4] + (data[4] - data[4] * 0.3)) / 2
  end
  if extra[Extras.daze] then
    -- Lets say daze is 65% the cooldown and 25% damage
    adj_dmg = adj_dmg * 1.25
    avg_cooldown = avg_cooldown * .65
  end
  if extra[Extras.bleed] then
    -- Bleed is complicated based on the victims PL, so lets just say its a +10%
    adj_dmg = adj_dmg * 1.10
  end
  if extra[Extras.piercing] then
    -- Lets just sat its a 5% boost since it reduces the targets armor, which might not
    -- be a whole lot
    adj_dmg = adj_dmg * 1.05
  end
  -- This is average DPS per round
  return (adj_dmg * avg_count) / avg_cooldown
end

local function curr_heat_used()
   return (Player.HEAT/100) * Player.MAXHEAT
end


function energy_cost(attack)
  data = energy_attacks[attack]
  if data == nil then
    return false
  end
  return data[1] + curr_heat_used() < Player.MAXHEAT
end

function melee_cost(attack)
  data = melee_attacks[attack]
  if data == nil then
    return false
  end
  -- zenzi says 4x
  return (data[1] * 2 + curr_heat_used()) < Player.MAXHEAT
end

local function filter_known(atable)
  local ndict = {}
  for attack, data in pairs(atable) do
    if Player.Learned[attack] then
      ndict[attack] = data
    end
  end
  if ndict["supergodfist"] then
    ndict["godfist"] = nil
  end
  return ndict
end

function get_dpr(attack)
  local attack_data
  local dpr
  local cost
  if melee_attacks[attack] then
  attack_data = melee_attacks[attack]
  cost = melee_cost(attack)
  dpr = attack_dpr(attack, attack_data)
  echo(string.format("DPR: %f, Afford: %s", dpr, cost and "true" or "false"))
  else
  attack_data = energy_attacks[attack]
  cost = energy_cost(attack)
  dpr = attack_dpr(attack, attack_data)
  echo(string.format("DPR: %f, Afford: %s", dpr, cost and "true" or "false"))
  end
end

local function dprify(atable)
  -- Turn the table into a name -> dpr
  -- dpr = damage per round (avg)
  local ntable = {}
  -- Get all the keys in a
  for k, data in pairs(atable) do
    ntable[k] = attack_dpr(k, data)
  end
  return ntable
end

local function attacksByValue(atable)
  local a = {}
  -- Get all the keys in a
  for n in pairs(atable) do
    table.insert(a, n)
  end
  
  local shuffled = {}
  for i, v in ipairs(a) do
	   local pos = math.random(1, #shuffled+1)
	   table.insert(shuffled, pos, v)
  end
  
  -- Sort the keys in a
  table.sort(
    shuffled,
    function(a, b)
      return atable[a] > atable[b]
    end
  )
  local i = 0
  -- iterator
  local iter =
    function()
      i = i + 1
      if shuffled[i] == nil then
        return nil
      else
        return shuffled[i], atable[shuffled[i]]
      end
    end
  return iter
end

local function getAttacks(atable, max, cost_func)
  local a = {}
  local count = 1
  for attack, dpr in attacksByValue(dprify(filter_known(atable))) do
    if count > max then
      break
    end
    if not (attack == "sweep" and Player.FLYING) then
      -- hack
      if cost_func(attack) then
        count = count + 1
        table.insert(a, attack)
      end
    end
  end
  return a
end

function cmd_fight(who)
  if not Toggles.standing then
    return nil
  end
  Times.lastfight = getEpoch()
  local ran = math.random()
  local fights = getAttacks(melee_attacks, 2, melee_cost)
  -- if no fights and we know who then kill them with autohits
  if #fights == 0 then
    if who then
      send("kill " .. string.lower(who))
    end
    return
  end
  -- We should attempt a combo 10% of the time
  if ran < 0.10 then
    echo("Lets start a combo")
  end
  if Player.COMBO or ran < 0.10 then
    if last_combo_id ~= COMBO_ID then
      last_combo_id = COMBO_ID
      send("--")
    end
    local next_fight = next_combo()
    if melee_cost(next_fight) then
      fights = {next_fight}
    else
      echo("Too Overheated for Combo: " .. next_fight)
    end
  end
  if Player.HEALTH < 60 and Player.HEAT < 90 then
    -- Heal me
    send("repair")
    return
  end
  local pos = math.floor(math.random() * #fights) + 1
  local next_attack = fights[pos]
  if who == nil then
    send(next_attack)
  else
    who = string.lower(who)
    fsend{next_attack, who}
  end
end

function cmd_blast(who)
  if not Toggles.standing then
    return nil
  end
  Times.lastfight = getEpoch()
  local HT = Player.HT and not Toggles.NEXTHT
  local fights = getAttacks(energy_attacks, HT and 1 or 3, energy_cost)
  -- if no fights and we know who then kill them with autohits
  if #fights == 0 then
    if who then
      send("kill " .. string.lower(who))
    end
    return
  end
  if Player.HEALTH < 60 and Player.HEAT < 90 then
    -- Heal me
    send("repair")
    return
  end
  
  if HT then
    Toggles.NEXTHT = true
    send("--")
  end
  local pos = math.floor(math.random() * #fights) + 1
  local next_attack = fights[pos]
  if who == nil then
    send(next_attack)
  else
    who = string.lower(who)
    fsend{next_attack, who}
  end
end