fullname_to_cmd =
  {
    ["whirlwind"] = "whirl",
    ["scatter shot"] = "scatter",
    ["mach punch"] = "machpunch",
    ["mach kick"] = "machkick",
    ["super big bang"] = "superbb",
    ["super kamehameha"] = "superk",
    ["spirit blast"] = "sblast",
    ["rage saucer"] = "rage",
    ["disruptor beam"] = "disrupt",
    ["braver strike"] = "braver",
    ["big bang"] = "bigbang",
    ["eye beam"] = "eyebeam",
    ["photon wave"] = "photon",
    ["dragon punch"] = "dpunch",
    ["renzokou energy dan"] = "renzo",
    ["final flash"] = "final",
    ["final kamehameha"] = "finalk",
    ["warp kamehameha"] = "warp",
    ["instant trans"] = "instant",
    ["hellsflash"] = "hells",
    ["justice blitz"] = "justice",
    ["cyclone kick"] = "cyclone",
    ["super godfist"] = "supergodfist",
    ["heel stomp"] = "heel",
    ["wolf fang fist"] = "wolf",
    ["chou kamehameha"] = "chou",
    ["spirit bomb"] = "genki",
    ["dynamite kick"] = "dynamite",
    ["taiyoken"] = "solarflare",
    ["suppression"] = "sup",
    ["kamehameha"] = "kame",
    ["makankosappo"] = "makan",
    ["unravel defense"] = "unravel",
  }

function toggle_trainingmode(target)
  if Toggles.training then
    -- disable it
    Toggles.training = false
    echo("Training Mode Disabled!!!")
    disableTimer("Trainer")
  else
    Toggles.training = true
    Toggles.botmode = false
    if target then
      autolearn_target = target
    else
      autolearn_target = "child"
    end
    echo("Training Mode Enabled!!!")
    enableTimer("Trainer")
    send("learn")
  end
end

local function has_power(attack)
  return energy_cost(attack) or melee_cost(attack)
end

function on_train()
  -- This is executed by a timer
  if is_connected() then
    if Toggles.training then
      local ran = math.random()
      if
        PromptCounters.timer_ok == nil or (PromptCounters.timer_ok <= 15 and not Toggles.fighting)
      then
        Toggles.timer_ok = true
      end
      Counters = Counters or {}
      Counters.timer_trainer = Counters.timer_trainer or 0
      local new_heat =
        skill_filter({"sweep", "punch", "kick", "roundhouse", "uppercut", "kishot"}, true)
      local learned_skills =
        skill_filter(
          {
            "sblast",
            "superk",
            "wolf",
            "photon",
            "warp",
            "braver",
            "machpunch",
            "kame",
            "heel",
            "kienzan",
            "superbb",
            "dpunch",
            "makan",
            "rage",
            "bigbang",
            "godfist",
            "eyebeam",
            "machkick",
            "disrupt",
            "cyclone",
            "justice",
            "finalk",
            "supergodfist",
            "genki",
            "dynamite",
            "chou",
          },
          true
        )
      local new_buffs =
        skill_filter(
          {
            "resonance",
            "forcefield",
            "herculean force",
            "infravision",
            "hasshuken",
            "zanzoken",
            "energy shield",
            "kino tsurugi",
          }
        )

      function get_learn_triggers()
        local new_dict =
          {
            ["scatter"] = {"kishot"},
            ["warp"] = {"superk", "instant"},
            ["superbb"] = {"bigbang"},
            ["superk"] = {"kame"},
            ["machpunch"] = {"punch"},
            ["machkick"] = {"kick"},
          }
        if Player.BASEPL > 125000000 then
          new_dict["finalk"] = {"warp", "final"}
          new_dict["justice"] = {"cyclone", "dynamite", "rage"}
          new_dict["supergodfist"] = {"godfist", "wolf", "dpunch"}
        end
        return new_dict
      end

      local UBSLBSSKILLS = {}
      if Player.UBS < 100 then
        UBSLBSSKILLS = {"machpunch", "punch"}
      end
      if Player.LBS < 100 then
        table.insert(UBSLBSSKILLS, "machkick")
        table.insert(UBSLBSSKILLS, "kick")
      end
      UBSLBSSKILLS = skill_filter_only_learned(UBSLBSSKILLS)
      local new_learn_other = filter_learn_triggers(get_learn_triggers())
      local new_other = skill_filter({"powersense", "solarflare", "unravel"}, true)
      local new_aoe = skill_filter({"hells", "final", "renzo", "scatter", "whirl"}, true)
      local new_goku_target = skill_filter({"instant"}, true)
      local target = {"gine", "roshi", "teragon", "malak", "bubbles", "cypher"}
      if is_state(State.NORMAL) and PromptFlags.timertrainer == nil then
        PromptFlags.timertrainer = true
        --Toggles.timer_ok = false
        ---fight("name")
        if true and Toggles.timer_ok then
          --(Player.FATIGUE <= 90 and Player.KI > 20) then
          if #new_heat > 0 and has_power(new_heat[1]) then
            Toggles.timer_ok = false
            PromptCounters.timer_ok = 20
            fsend{new_heat[1], autolearn_target}
          elseif #learned_skills > 0 and has_power(learned_skills[1]) then
            Toggles.timer_ok = false
            PromptCounters.timer_ok = 20
            fsend({learned_skills[1], autolearn_target})
          elseif #new_other > 0 and Player.HEAT < 90 then
            Toggles.timer_ok = true
            fsend({new_other[1], autolearn_target})
          elseif #new_learn_other > 0 and has_power(new_learn_other[1]) then
            Toggles.timer_ok = false
            PromptCounters.timer_ok = 20
            fsend({new_learn_other[1], autolearn_target})
          elseif #new_buffs > 0 and Player.HEAT < 90 then
            Toggles.timer_ok = true
            PromptCounters.timer_ok = 20
            focus_buff(new_buffs[1])
          elseif #new_aoe > 0 and Player.HEAT < 90 then
            Toggles.timer_ok = false
            PromptCounters.timer_ok = 20
            send(new_aoe[1])
          elseif #new_goku_target > 0 and Player.HEAT < 80 then
            Toggles.timer_ok = true
            fsend({random_list_elem(new_goku_target), random_list_elem(target)})
          elseif Player.HEAT < 90 and Player.Learned["sup"] and Player.Mastered["sup"] == nil then
            local alist = skill_filter({"sup"})
            if #alist > 0 then
              send("sup 10")
              send("sup")
            end
          elseif Player.HEAT < 90 and Player.Learned["scan"] and Player.Mastered["scan"] == nil then
            send("scan")
          elseif Player.HEAT < 90 and #UBSLBSSKILLS > 0 then
            local lfight = random_list_elem(UBSLBSSKILLS)
            Toggles.timer_ok = false
            PromptCounters.timer_ok = 20
            fsend({lfight, autolearn_target})
          elseif Player.HEAT > 0 then
            set_state(State.REST)
            send("vent")
            send("repair")
          end
        end
      end
    end
  end
end

function translate_skill_name(raw)
  local lraw = string.lower(raw)
  local cmd_name = fullname_to_cmd[lraw]
  if cmd_name ~= nil then
    return cmd_name
  end
  return lraw
end

function filter_learn_triggers(adict)
  local nlist = {}
  -- k = skill to learn,  v is table each element must be mastered but first item is learn command
  for k, v in pairs(adict) do
    if Player.Learned[k] ~= true then
      local all_reqs = true
      for _, v1 in ipairs(v) do
        if Player.Mastered[v1] ~= true then
          all_reqs = false
          break
        end
      end
      if all_reqs then
        table.insert(nlist, v[1])
      end
    end
  end
  return nlist
end

function skill_filter(alist, must_be_learned)
  if must_be_learned == nil then
    must_be_learned = false
  end
  local nlist = {}
  for i, v in ipairs(alist) do
    if Player.Mastered[v] ~= true and (not must_be_learned or Player.Learned[v] == true) then
      table.insert(nlist, v)
    end
  end
  return nlist
end

function skill_filter_only_learned(alist)
  local nlist = {}
  for i, v in ipairs(alist) do
    if Player.Learned[v] then
      table.insert(nlist, v)
    end
  end
  return nlist
end

function known_skills()
  local nlist = {}
  for k, _ in pairs(Player.Learned or {}) do
    table.insert(nlist, k)
  end
  return nlist
end