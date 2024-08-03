function enter_botmode()
  Toggles.timer_ok = true
  enableTimer("BotMode")
end

function exit_botmode()
  disableTimer("BotMode")
end

function toggle_botmode()
  if Toggles.botmode then
    -- disable it
    Toggles.botmode = false
    echo("BOT Mode Disabled!!!")
    set_state(State.NORMAL)
    exit_botmode()
  else
    Toggles.botmode = true
    Toggles.training = false
    set_state(State.NORMAL)
    echo("BOT Mode Enabled!!!")
    enter_botmode()
  end
end

function on_botmode()
  -- This is executed by a timer when botmode is on
  ok_to_vent = ok_to_vent or true
  TimerCount = TimerCount or 0
  local ran = math.random()
  Times.lastaoe = Times.lastaoe or getEpoch()
  if PromptCounters.timer_ok == nil or (PromptCounters.timer_ok <= 17 and not Toggles.fighting) then
    Toggles.timer_ok = true
  end
  if is_connected() then
    if Toggles.botmode and PromptFlags.timertrainer == nil then
      PromptFlags.timertrainer = true
      --Toggles.timer_ok = false
      ---fight("name")
      if Toggles.timer_ok then
        if is_state(State.NORMAL, true) and Player.HEALTH > 50 and Player.HEAT <= 80 then
          Toggles.timer_ok = false
          TimerCount = TimerCount + 1
          PromptCounters.timer_ok = 20
          ok_to_vent = true

          if last(Times.lastaoe) > 32 then
            send("configure " .. Settings.config_attack or 90)
          end
          --send("sense sunburst")
          --send("superk name")
          --send("sense juggler")
          --send("sense gargoyle")
          if TimerCount >= 3 then
            send("sense genin")
            TimerCount = 0
          end
          send("hells")
          --fight("saiyan")
          --send("focus 'instant' goku")
          --send("adjust " .. (max_gravity or 2) - 1)
          --send("multiform")
          --send("warpk clone")
          Times.lastaoe = getEpoch()
        end
        if is_state(State.NORMAL, true) and last(Times.lastrip) > 600 then
          Toggles.timer_ok = true
          --send("focus 'instant' gargoyle")
          --send("focus 'instant' torrential wisp")
          send("instant genin")
        end
      end
      --[[
  if Player.HEALTH < 75 and Player.KI > 15 then
    heal()
  end
  if not Toggles.fighting and Player.HEALTH < 95 and Player.KI > 20 then
    heal()
  end
  if not Toggles.fighting and last(Times.lastrip) > 600 then
    send("portal Sparring Partner")
    send("sense chuuin")
    send("auto void partner")
  end
  ]]
    end
    if false and Toggles.training and PromptFlags.timertrainer == nil then
      PromptFlags.timertrainer = true
      if
        (not Toggles.fighting or (Toggles.fighting and Toggles.timer_ok)) and
        is_state(State.NORMAL, true) and
        Player.HEAT <= 80
      then
        ok_to_vent = true
        Toggles.timer_ok = false
        PromptCounters.timer_ok = 20
        cost = energy_cost(1000)
        if cost + Player.HEAT <= 100 then
          if ran < 1 / 2 then
            send("unravel child")
          else
            send("solarflare child")
          end
        else
          set_state(State.REST)
          send("vent")
        end
      end
    end
  end
end